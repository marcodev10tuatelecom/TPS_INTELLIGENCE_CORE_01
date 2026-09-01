-- TPSDBCORE01 | D3KA COVERAGE REGISTRY | R2 DML | NOT DEPLOYED
MERGE INTO tps_fact_class t
USING (
  SELECT 'ORG_OWNS_NETWORK' k,'ORGANIZATION' d,1 e,'Organization ownership of network' x FROM dual UNION ALL
  SELECT 'NETWORK_OWNS_STATION','ORGANIZATION',1,'Network ownership of station' FROM dual UNION ALL
  SELECT 'STATION_BROADCASTS_CHANNEL','MEDIA',1,'Station broadcasts channel' FROM dual UNION ALL
  SELECT 'STATION_AFFILIATED_WITH_NETWORK','ORGANIZATION',1,'Station/network affiliation' FROM dual UNION ALL
  SELECT 'REPEATER_REPEATS_STATION','MEDIA',1,'Repeater relation to origin station' FROM dual UNION ALL
  SELECT 'STATION_SERVES_REGION','GEOGRAPHY',1,'Station regional service' FROM dual UNION ALL
  SELECT 'PERSON_PRESENTS_PROGRAM','PROGRAMMING',1,'Presenter assignment' FROM dual UNION ALL
  SELECT 'PERSON_PRODUCES_PROGRAM','PROGRAMMING',1,'Producer assignment' FROM dual UNION ALL
  SELECT 'PROGRAM_SCHEDULED_ON_CHANNEL','PROGRAMMING',1,'Program/channel schedule relation' FROM dual UNION ALL
  SELECT 'CONTENT_PLAYED_ON_CHANNEL','PROGRAMMING',1,'Content playout relation' FROM dual UNION ALL
  SELECT 'ARTIST_PERFORMS_SONG','MUSIC',1,'Performance relationship' FROM dual UNION ALL
  SELECT 'SONG_FEATURES_ARTIST','MUSIC',1,'Featured artist relationship' FROM dual UNION ALL
  SELECT 'ALBUM_FEATURES_RECORDING','MUSIC',1,'Album recording membership' FROM dual UNION ALL
  SELECT 'ASSET_MASTER_OF_CONTENT','MEDIA_ASSET',1,'Asset master lineage' FROM dual UNION ALL
  SELECT 'ASSET_TRANSCODED_FROM_ASSET','MEDIA_ASSET',1,'Transcode lineage' FROM dual UNION ALL
  SELECT 'CAMPAIGN_TARGETS_AUDIENCE','COMMERCIAL',1,'Campaign target segment' FROM dual UNION ALL
  SELECT 'CAMPAIGN_SPONSORED_BY_ADVERTISER','COMMERCIAL',1,'Campaign sponsorship' FROM dual UNION ALL
  SELECT 'COMMERCIAL_SCHEDULED_ON_CHANNEL','COMMERCIAL',1,'Commercial scheduling' FROM dual UNION ALL
  SELECT 'CONTENT_LICENSED_BY_HOLDER','RIGHTS',1,'Content licensing source' FROM dual UNION ALL
  SELECT 'CONTENT_AUTHORIZED_FOR_REGION','RIGHTS',1,'Territorial authorization' FROM dual UNION ALL
  SELECT 'CONTENT_PROHIBITED_IN_REGION','RIGHTS',1,'Territorial prohibition' FROM dual UNION ALL
  SELECT 'CONTENT_AVAILABLE_IN_REGION','RIGHTS',1,'Availability by region' FROM dual UNION ALL
  SELECT 'CONTENT_POPULAR_IN_SEGMENT','AUDIENCE',1,'Observed popularity relation' FROM dual UNION ALL
  SELECT 'CONTENT_RECOMMENDED_FOR_SEGMENT','AUDIENCE',1,'Recommendation relation' FROM dual UNION ALL
  SELECT 'CONTENT_SIMILAR_TO_CONTENT','INTELLIGENCE',1,'Semantic/curated similarity' FROM dual UNION ALL
  SELECT 'ARTICLE_MENTIONS_ENTITY','EDITORIAL',1,'Editorial mention relation' FROM dual UNION ALL
  SELECT 'ARTICLE_REFERENCES_SOURCE','EDITORIAL',1,'Editorial source reference' FROM dual UNION ALL
  SELECT 'ASSERTION_DERIVED_FROM_SOURCE','KNOWLEDGE',1,'Knowledge derivation' FROM dual UNION ALL
  SELECT 'CONTENT_GENERATED_BY_AI','AI',1,'AI generation relation' FROM dual UNION ALL
  SELECT 'ENTITY_CLASSIFIED_AS_ENTITY','KNOWLEDGE',1,'Classification relation' FROM dual UNION ALL
  SELECT 'EVENT_PAYLOAD_LEDGER','EVENT',0,'Event payload remains event/ledger fact' FROM dual UNION ALL
  SELECT 'ASSET_HASH_SCALAR','MEDIA_ASSET',0,'SHA256 is canonical scalar property' FROM dual UNION ALL
  SELECT 'VECTOR_EMBEDDING_NUMERIC','VECTOR',0,'Embedding itself is vector value, linked to entity' FROM dual UNION ALL
  SELECT 'AUDIENCE_METRIC_VALUE','AUDIENCE',0,'Numeric metric remains observation fact' FROM dual
) s ON(t.fact_class_key=s.k)
WHEN MATCHED THEN UPDATE SET t.domain_code=s.d,t.description=s.x,t.d3ka_eligible=s.e
WHEN NOT MATCHED THEN INSERT(fact_class_key,domain_code,description,d3ka_eligible) VALUES(s.k,s.d,s.x,s.e);
