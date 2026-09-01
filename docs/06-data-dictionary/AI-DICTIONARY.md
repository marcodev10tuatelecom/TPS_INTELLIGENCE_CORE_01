# AI Object Dictionary

TPS_AI_MODEL: governed logical model/provider/version and classification metadata.
TPS_AI_AGENT: governed agent identity/config lifecycle, not secrets.
TPS_AI_TOOL: tool catalog/authority class.
TPS_AI_DECISION: material recommendation/decision trace linking request context, retrieved evidence, model, agent, policy result, final action and human override.

Provider credentials, wallet files and API keys are explicitly excluded from tables designed for ordinary business metadata and excluded from Git.
