# TPS_ENTITY Data Dictionary

Purpose: universal canonical identity.

Planned columns: ENTITY_ID numeric generated PK; ENTITY_TYPE_ID FK; CANONICAL_KEY stable unique business key; CANONICAL_NAME; STATE; ATTRIBUTES_JSON native JSON; VALID_FROM; VALID_TO; CREATED_AT; UPDATED_AT; CREATED_BY; UPDATED_BY.

STATE vocabulary initially ACTIVE, INACTIVE, SUPERSEDED, RETIRED. Deletion of referenced canonical entities is normally replaced by lifecycle transition/supersession.

Canonical keys are human/system-stable identifiers distinct from surrogate ENTITY_ID.
