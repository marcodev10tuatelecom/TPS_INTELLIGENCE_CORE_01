-- TPSDBCORE01 | MEDIA DOMAIN | R1 | NOT DEPLOYED
CREATE TABLE tps_station (
    station_entity_id     NUMBER PRIMARY KEY,
    station_kind          VARCHAR2(20) NOT NULL,
    default_timezone      VARCHAR2(100) NOT NULL,
    country_code          VARCHAR2(3),
    regulatory_reference VARCHAR2(300),
    operational_state    VARCHAR2(30) DEFAULT 'ACTIVE' NOT NULL,
    attributes_json      JSON,
    CONSTRAINT fk_tps_station_entity FOREIGN KEY(station_entity_id) REFERENCES tps_entity(entity_id),
    CONSTRAINT ck_tps_station_kind CHECK(station_kind IN ('RADIO','TV','HYBRID','OTHER')),
    CONSTRAINT ck_tps_station_state CHECK(operational_state IN ('ACTIVE','INACTIVE','MAINTENANCE','RETIRED'))
);
