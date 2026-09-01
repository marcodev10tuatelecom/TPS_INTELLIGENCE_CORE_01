-- TPSDBCORE01 | COMMERCIAL DOMAIN | R1 | NOT DEPLOYED
CREATE TABLE tps_campaign (
    campaign_entity_id    NUMBER PRIMARY KEY,
    advertiser_entity_id  NUMBER NOT NULL,
    contract_entity_id    NUMBER,
    valid_from            TIMESTAMP WITH TIME ZONE NOT NULL,
    valid_to              TIMESTAMP WITH TIME ZONE NOT NULL,
    max_frequency_window_sec NUMBER,
    max_frequency_count   NUMBER,
    state                 VARCHAR2(30) DEFAULT 'DRAFT' NOT NULL,
    rules_json            JSON,
    CONSTRAINT fk_tps_campaign_entity FOREIGN KEY(campaign_entity_id) REFERENCES tps_entity(entity_id),
    CONSTRAINT fk_tps_campaign_advertiser FOREIGN KEY(advertiser_entity_id) REFERENCES tps_entity(entity_id),
    CONSTRAINT fk_tps_campaign_contract FOREIGN KEY(contract_entity_id) REFERENCES tps_entity(entity_id),
    CONSTRAINT ck_tps_campaign_time CHECK(valid_to > valid_from),
    CONSTRAINT ck_tps_campaign_state CHECK(state IN ('DRAFT','APPROVED','ACTIVE','PAUSED','EXPIRED','CANCELLED'))
);
