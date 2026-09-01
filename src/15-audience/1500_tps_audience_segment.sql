-- TPSDBCORE01 | AUDIENCE DOMAIN | R1 | NOT DEPLOYED
CREATE TABLE tps_audience_segment (
    segment_entity_id     NUMBER PRIMARY KEY,
    definition_json       JSON NOT NULL,
    privacy_class         VARCHAR2(30) DEFAULT 'AGGREGATE' NOT NULL,
    state                 VARCHAR2(30) DEFAULT 'ACTIVE' NOT NULL,
    CONSTRAINT fk_tps_audience_segment_entity FOREIGN KEY(segment_entity_id) REFERENCES tps_entity(entity_id),
    CONSTRAINT ck_tps_audience_privacy CHECK(privacy_class IN ('AGGREGATE','PSEUDONYMOUS','PERSONAL_RESTRICTED')),
    CONSTRAINT ck_tps_audience_state CHECK(state IN ('ACTIVE','INACTIVE','SUPERSEDED','RETIRED'))
);
