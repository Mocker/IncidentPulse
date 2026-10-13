BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "service" ADD COLUMN "monitoringEnabled" boolean NOT NULL DEFAULT true;

--
-- MIGRATION VERSION FOR incident_pulse
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('incident_pulse', '20261013040313994', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261013040313994', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20260824182343939', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182343939', "timestamp" = now();


COMMIT;
