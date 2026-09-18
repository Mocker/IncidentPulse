.PHONY: up down generate run test help

help:
	@echo "IncidentPulse Development Commands:"
	@echo "  make up        - Start local Postgres and Redis containers"
	@echo "  make down      - Stop local Postgres and Redis containers"
	@echo "  make generate  - Run Serverpod code generator (serverpod generate)"
	@echo "  make run       - Run Serverpod backend server locally"
	@echo "  make test      - Run automated Dart tests"

up:
	docker compose up -d

down:
	docker compose down

generate:
	cd incident_pulse_server && serverpod generate

run:
	cd incident_pulse_server && dart run bin/main.dart --mode development

test:
	cd incident_pulse_server && dart test
