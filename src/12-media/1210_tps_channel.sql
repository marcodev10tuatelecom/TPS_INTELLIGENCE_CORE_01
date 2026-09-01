-- TPSDBCORE01 | MEDIA DOMAIN | R1 | NOT DEPLOYED
CREATE TABLE tps_channel (
    channel_entity_id     NUMBER PRIMARY KEY,
    channel_kind          VARCHAR2(30) NOT NULL,
    service_key           VARCHAR2(200),
    default_timezone      VARCHAR2(100) NOT NULL,
    operational_state    VARCHAR2(30) DEFAULT 'ACTIVE' NOT NULL,
    attributes_json      JSON,
    CONSTRAINT fk_tps_channel_entity FOREIGN KEY(channel_entity_id) REFERENCES tps_entity(entity_id),
    CONSTRAINT ck_tps_channel_state CHECK(operational_state IN ('ACTIVE','INACTIVE','MAINTENANCE','RETIRED'))
);
