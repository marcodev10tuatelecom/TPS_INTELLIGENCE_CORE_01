-- TPSDBCORE01 | MIGRATION LEDGER | R1 | NOT DEPLOYED
CREATE TABLE tps_schema_migration (
    migration_id          VARCHAR2(100) PRIMARY KEY,
    release_version       VARCHAR2(50) NOT NULL,
    git_commit_sha        VARCHAR2(64) NOT NULL,
    source_sha256         VARCHAR2(64) NOT NULL,
    change_id             VARCHAR2(200) NOT NULL,
    reversibility_class   VARCHAR2(10) NOT NULL,
    started_at            TIMESTAMP WITH TIME ZONE NOT NULL,
    completed_at          TIMESTAMP WITH TIME ZONE,
    applied_by            VARCHAR2(128) NOT NULL,
    status                VARCHAR2(20) NOT NULL,
    evidence_ref          VARCHAR2(1000),
    CONSTRAINT ck_tps_migration_rev CHECK(reversibility_class IN ('R0','R1','R2','R3','R4')),
    CONSTRAINT ck_tps_migration_status CHECK(status IN ('STARTED','PASS','FAIL','ROLLED_BACK','COMPENSATED'))
);
