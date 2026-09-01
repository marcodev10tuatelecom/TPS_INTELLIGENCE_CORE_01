# Programming and Scheduling Domain

Canonical concepts: PROGRAM, SCHEDULE, SCHEDULE_ITEM, CLOCK_TEMPLATE, CONTENT_SLOT, LIVE_WINDOW, LOCAL_OVERRIDE, CONTINUITY_RULE.

Scheduling is both relational/event-oriented and graph-connected. A schedule item points to canonical program/content entities and carries station/channel/time/context/policy state.

Priority order is explicit: emergency/mandatory policy > legal/rights restrictions > approved local override > network schedule > fallback/continuity schedule. AI may recommend but cannot bypass this order.

24x7 continuity requirement: the Core must be able to describe what should air when local production disconnects. The execution system may be outside Oracle, but schedule/fallback authority and observed playout events are represented canonically.
