# TPS D3KA — Context Semantics v0.01

## Purpose

Make the same canonical entity/relation usable across network, station, affiliate, repeater, region, channel, program, audience and commercial situations without cloning entities or schemas.

## Context forms

- atomic: one dimension, e.g. REGION=BR-SP;
- composite: multiple dimensions, e.g. STATION=TVKIDS + PROGRAM=MORNING_KIDS + REGION=BR-SP;
- hierarchical: network -> station -> affiliate/repeater/local;
- operational: emergency/fallback/maintenance;
- policy: rights/commercial/regulatory qualifier.

## Resolution

Context selection requires an explicit resolver that evaluates applicability, specificity, precedence and policy. The resolver must be deterministic for protected decisions and must expose why one contextual relation superseded another.

## Local versus network programming

Network schedule is not copied into every local station. Local stations reference shared canonical programs/content. `LOCAL_OVERRIDE` context qualifies the schedule or relation and receives a defined precedence window. Outside that window, network/fallback programming resumes.

## Data design

Frequently queried canonical context dimensions can use normalized entity references inside context payloads or dedicated linking tables. `context_json` is for extensibility, not a replacement for entity identity. Validation schemas/constraints may be added as context types mature.
