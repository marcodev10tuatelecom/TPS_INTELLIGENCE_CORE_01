# TPS D3KA — Logical Coverage Metric v0.01

## Target

`D3KA_LOGICAL_COVERAGE >= 0.90` for eligible canonical business fact classes before CORE-15 PASS.

## Denominator governance

The denominator is not arbitrary table count. `TPS_FACT_CLASS` inventories meaningful domain fact classes. Each fact class declares whether D3KA representation is semantically appropriate. Scalar measurements, immutable hashes, raw event payloads and vector numeric values may be non-eligible while linking to graph entities.

## Numerator

An eligible fact class counts as represented only when it has a mapping to a relation type and implementation status at least IMPLEMENTED. Certification may separately report VALIDATED and CERTIFIED coverage.

## Anti-gaming rules

- non-eligible requires written rationale;
- trivial artificial fact classes cannot inflate numerator;
- weighted and unweighted coverage are both visible;
- domains with P0 requirements receive independent coverage breakdown;
- a relation mapping is not enough if invariants/tests fail.

## Reports

Report total eligible, represented, validated, certified, per-domain percentages, unmapped fact classes and blockers.
