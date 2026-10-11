#!/usr/bin/env python3
"""
IncidentPulse Mock Emitter
Simulates external services (Stripe, Sentry, Uptime) emitting webhooks
to IncidentPulse's ingest endpoint.

The live Serverpod API expects flat JSON params (NOT nested under
"params"): {"method": "ingestWebhook", "webhookKey": ..., ...}.
Auth is by service webhookKey; no HMAC needed for ingress.

Usage:
  # against the live Cloud API (webhook key via env or flag)
  INCIDENTPULSE_API_URL=https://incident-pulse.api.serverpod.space \\
  INCIDENTPULSE_WEBHOOK_KEY=<service webhookKey> \\
      ./scripts/mock_emitter.py all

  # against local staging
  ./scripts/mock_emitter.py sentry --url http://localhost:8080 --key <webhookKey>

  # interactive menu
  ./scripts/mock_emitter.py
"""

import argparse
import http.client
import json
import os
import sys
import time
import urllib.request
import urllib.error


def api_base_url(cli_url: str | None) -> str:
    return (
        cli_url
        or os.environ.get("INCIDENTPULSE_API_URL")
        or "http://localhost:8080"
    ).rstrip("/")


def send_webhook(base_url: str, webhook_key: str, source: str, payload: dict) -> bool:
    url = f"{base_url}/webhook"
    # Flat params — Serverpod endpoint named parameters, not nested.
    body = json.dumps({
        "method": "ingestWebhook",
        "webhookKey": webhook_key,
        "source": source,
        "rawPayloadJson": json.dumps(payload),
    }).encode("utf-8")

    req = urllib.request.Request(
        url,
        data=body,
        headers={"Content-Type": "application/json"},
    )

    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            result = resp.read().decode("utf-8").strip()
            print(f"[{source.upper()}] -> HTTP {resp.status}, ingest={result}")
            return result == "true"
    except urllib.error.HTTPError as e:
        print(f"[{source.upper()}] HTTP {e.code} from {url}")
        return False
    except urllib.error.URLError as e:
        print(f"[{source.upper()}] Failed to reach {url}: {e}")
        return False
    except (ConnectionResetError, http.client.RemoteDisconnected) as e:
        # The request may have been processed; the response was lost.
        # Check the dashboard / getActiveIncidents to confirm.
        print(f"[{source.upper()}] Response lost ({e}); verify in dashboard.")
        return False


def mock_stripe_payment_failure(base_url: str, webhook_key: str):
    """Simulates a Stripe payment failure on a micro-venture checkout."""
    payload = {
        "id": f"evt_mock_{int(time.time())}",
        "type": "payment_intent.payment_failed",
        "data": {
            "object": {
                "id": "pi_3MmockFailedPayment",
                "amount": 4900,
                "currency": "usd",
                "last_payment_error": {
                    "code": "card_declined",
                    "decline_code": "insufficient_funds",
                    "message": "The customer card was declined due to insufficient funds.",
                },
            }
        },
    }
    print("Simulating Stripe payment_intent.payment_failed...")
    return send_webhook(base_url, webhook_key, "stripe", payload)


def mock_sentry_crash(base_url: str, webhook_key: str, project_name: str = "Chaos Monkey"):
    """Simulates a Sentry unhandled exception stack trace."""
    payload = {
        "project_name": project_name,
        "level": "fatal",
        "message": "ConnectionRefusedError: Unable to connect to Redis cache cluster at redis://10.0.4.12:6379",
        "culprit": "cache_manager.py:connect_with_retry",
        "url": "https://sentry.io/organizations/mocker/issues/49912093/",
        "stacktrace": [
            "File 'server.py', line 114, in handle_request",
            "File 'cache_manager.py', line 45, in get_session",
            "ConnectionRefusedError: [Errno 111] Connection refused",
        ],
    }
    print(f"Simulating Sentry crash alert for {project_name}...")
    return send_webhook(base_url, webhook_key, "sentry", payload)


def mock_uptime_outage(base_url: str, webhook_key: str, service_name: str = "Chaos Monkey"):
    """Simulates a synthetic uptime health probe failure."""
    payload = {
        "service": service_name,
        "statusCode": 503,
        "responseTimeMs": 10045,
        "error": "Gateway Timeout / Service Unavailable",
    }
    print(f"Simulating Uptime outage alert for {service_name}...")
    return send_webhook(base_url, webhook_key, "uptime", payload)


def resolve_key(cli_key: str | None) -> str:
    key = cli_key or os.environ.get("INCIDENTPULSE_WEBHOOK_KEY") or ""
    if not key:
        key = input("Enter target Service Webhook Key: ").strip()
    if not key:
        print("A service webhookKey is required.", file=sys.stderr)
        sys.exit(2)
    return key


def interactive_menu(base_url: str, cli_key: str | None):
    print("\n==============================================")
    print("IncidentPulse Mock Emitter")
    print(f"Target: {base_url}/webhook")
    print("==============================================")
    print("1. Simulate Stripe Payment Failure (Critical Severity)")
    print("2. Simulate Sentry Crash / Exception (High Severity)")
    print("3. Simulate Uptime Outage / 503 Gateway Timeout (Critical)")
    print("4. Fire All 3 Scenario Alerts (Full Smoke Test)")
    print("Q. Quit")
    print("----------------------------------------------")

    key = resolve_key(cli_key)
    choice = input("Select scenario [1-4, Q]: ").strip()
    if choice == "1":
        mock_stripe_payment_failure(base_url, key)
    elif choice == "2":
        mock_sentry_crash(base_url, key)
    elif choice == "3":
        mock_uptime_outage(base_url, key)
    elif choice == "4":
        mock_stripe_payment_failure(base_url, key)
        time.sleep(1)
        mock_sentry_crash(base_url, key)
        time.sleep(1)
        mock_uptime_outage(base_url, key)
    elif choice.lower() == "q":
        sys.exit(0)
    else:
        print(f"Unknown choice: {choice}", file=sys.stderr)
        sys.exit(2)


def main() -> int:
    parser = argparse.ArgumentParser(description="Emit mock webhooks to IncidentPulse")
    parser.add_argument("scenario", nargs="?", choices=["stripe", "sentry", "uptime", "all"],
                        help="scenario to fire (omit for interactive menu)")
    parser.add_argument("--url", default=None, help="API base URL (or INCIDENTPULSE_API_URL)")
    parser.add_argument("--key", default=None, help="service webhookKey (or INCIDENTPULSE_WEBHOOK_KEY)")
    args = parser.parse_args()

    base_url = api_base_url(args.url)

    if args.scenario is None:
        interactive_menu(base_url, args.key)
        return 0

    key = resolve_key(args.key)
    ok = True
    if args.scenario in ("stripe", "all"):
        ok &= mock_stripe_payment_failure(base_url, key)
    if args.scenario in ("sentry", "all"):
        ok &= mock_sentry_crash(base_url, key)
    if args.scenario in ("uptime", "all"):
        ok &= mock_uptime_outage(base_url, key)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
