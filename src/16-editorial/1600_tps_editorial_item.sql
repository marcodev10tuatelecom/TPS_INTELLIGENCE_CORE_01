-- TPSDBCORE01 | EDITORIAL DOMAIN | R1 | NOT DEPLOYED
CREATE TABLE tps_editorial_item (
    editorial_entity_id   NUMBER PRIMARY KEY,
    editorial_class       VARCHAR2(40) NOT NULL,
    publication_state     VARCHAR2(30) DEFAULT 'DRAFT' NOT NULL,
    published_at          TIMESTAMP WITH TIME ZONE,
    source_id             NUMBER,
    content_json          JSON,
    CONSTRAINT fk_tps_editorial_entity FOREIGN KEY(editorial_entity_id) REFERENCES tps_entity(entity_id),
    CONSTRAINT fk_tps_editorial_source FOREIGN KEY(source_id) REFERENCES tps_source(source_id),
    CONSTRAINT ck_tps_editorial_class CHECK(editorial_class IN ('NEWS','REPORT','INTERVIEW','PODCAST','EPISODE','ARTICLE','NOTICE')),
    CONSTRAINT ck_tps_editorial_state CHECK(publication_state IN ('DRAFT','REVIEW','APPROVED','PUBLISHED','CORRECTED','RETRACTED','ARCHIVED'))
);
