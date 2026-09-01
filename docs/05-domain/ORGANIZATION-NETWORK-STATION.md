# Organization, Network, Station and Distribution Domain

Canonical entity types: ORGANIZATION, NETWORK, BRAND, RADIO_STATION, TV_STATION, CHANNEL, AFFILIATE, REPEATER, REGION, LOCATION.

Core relations: OWNS, OPERATES, MANAGES, BELONGS_TO, AFFILIATED_WITH, REPEATS, BROADCASTS, AVAILABLE_IN, SERVES_REGION.

An affiliate retains independent identity and relates to a network/station through explicit affiliation contracts/context. A repeater represents distribution/repetition and may carry local/regional context; it is not silently collapsed into the origin station.

Station/channel identity is separate: one station may operate multiple channels; one network may own multiple stations; regional schedule context qualifies relationships rather than creating duplicate content entities.
