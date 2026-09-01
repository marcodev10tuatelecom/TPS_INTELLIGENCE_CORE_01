-- TPSDBCORE01 | PROGRAMMING DOMAIN | R1 | NOT DEPLOYED
CREATE TABLE tps_program (
    program_entity_id     NUMBER PRIMARY KEY,
    program_format        VARCHAR2(80),
    default_duration_sec  NUMBER,
    editorial_rating      VARCHAR2(50),
    attributes_json       JSON,
    CONSTRAINT fk_tps_program_entity FOREIGN KEY(program_entity_id) REFERENCES tps_entity(entity_id),
    CONSTRAINT ck_tps_program_duration CHECK(default_duration_sec IS NULL OR default_duration_sec > 0)
);
