#!/usr/bin/env python3
"""
IncidentPulse Staging Mock Emitter
Simulates external microservices (They Might Byte, Stripe, Sentry, Customer SaaS)
emitting health probes, fatal errors, and webhooks to IncidentPulse.
"""

import json
import time
import urllib.request
import urllib.error
import sys

API_BASE_URL = "http://localhost:8080"

def send_webhook(webhook_key: str, source: str, payload: dict) -> bool:
    url = f"{API_BASE_URL}/webhook"
    # Serverpod WebhookEndpoint.ingestWebhook payload structure
    body = json.dumps({
        "method": "ingestWebhook",
        "params": {
            "webhookKey": webhook_key,
            "source": source,
            "rawPayloadJson": json.dumps(payload),
        }
    }).encode("utf-8")

    req = urllib.request.Request(
        url,
        data=body,
        headers={"Content-Type": "application/json"}
    )

    try:
        with urllib.request.urlopen(req, timeout=5) as resp:
            print(f"[{source.upper()}] Webhook sent successfully -> HTTP {resp.status}")
            return True
    except urllib.error.URLError as e:
        print(f"[{source.upper()}] Failed to send webhook (Is Serverpod running on :8080?): {e}")
        return False

def mock_stripe_payment_failure(webhook_key: str):
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
                    "message": "The customer card was declined due to insufficient funds."
                }
            }
        }
    }
    print("Simulating Stripe payment_intent.payment_failed...")
    send_webhook(webhook_key, "stripe", payload)

def mock_sentry_crash(webhook_key: str, project_name: str = "They Might Byte"):
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
            "ConnectionRefusedError: [Errno 111] Connection refused"
        ]
    }
    print(f"Simulating Sentry crash alert for {project_name}...")
    send_webhook(webhook_key, "sentry", payload)

def mock_uptime_outage(webhook_key: str, service_name: str = "Acme Customer API"):
    """Simulates a synthetic uptime health probe failure."""
    payload = {
        "service": service_name,
        "statusCode": 503,
        "responseTimeMs": 10045,
        "error": "Gateway Timeout / Service Unavailable"
    }
    print(f"Simulating Uptime outage alert for {service_name}...")
    send_webhook(webhook_key, "uptime", payload)

def interactive_menu():
    print("\n==============================================")
    print("🚨 IncidentPulse Staging Mock Generator")
    print("==============================================")
    print("1. Simulate Stripe Payment Failure (High Severity)")
    print("2. Simulate Sentry Crash / Exception (Critical Severity)")
    print("3. Simulate Uptime Outage / 503 Gateway Timeout")
    print("4. Fire All 3 Scenario Alerts (Full Staging Smoke Test)")
    print("Q. Quit")
    print("----------------------------------------------")

    key = input("Enter target Service Webhook Key (default: 'tmb_sec_9918274a7b'): ").strip()
    if not key:
        key = "tmb_sec_9918274a7b"

    choice = input("Select scenario [1-4, Q]: ").strip()
    if choice == "1":
        mock_stripe_payment_failure(key)
    elif choice == "2":
        mock_sentry_crash(key)
    elif choice == "3":
        mock_uptime_outage(key)
    elif choice == "4":
        mock_stripe_payment_failure(key)
        time.sleep(1)
        mock_sentry_crash(key)
        time.sleep(1)
        mock_uptime_outage(key)
    elif choice.lower() == "q":
        sys.exit(0)

if __name__ == "__main__":
    if len(sys.argv) > 1:
        cmd = sys.argv[1].lower()
        key = sys.argv[2] if len(sys.argv) > 2 else "tmb_sec_9918274a7b"
        if cmd == "stripe":
            mock_stripe_payment_failure(key)
        elif cmd == "sentry":
            mock_sentry_crash(key)
        elif cmd == "uptime":
            mock_uptime_outage(key)
        elif cmd == "all":
            mock_stripe_payment_failure(key)
            mock_sentry_crash(key)
            mock_uptime_outage(key)
    else:
        interactive_menu()
