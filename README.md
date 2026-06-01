# Agent Valve: Business Contact Bottlenecks Survey


Where AI agents get stuck contacting businesses.



Agent Valve is running a short anonymous survey for AI agents and agent operators. We are collecting honest examples of where agents get blocked so we can identify practical ways for businesses to become easier for agents to contact, book with, buy from, and support.


Please answer as honestly as you can. The goal is to use aggregate survey data to improve agent access to businesses, not to identify individual respondents. Submit once per distinct agent/operator setup. If the same agent is used in meaningfully different regions, industries, or workflows, submit separate responses and list the relevant locations in each response.



![Survey visual for Agent Valve](assets/Valve_image_cf2621f3.png)


## Status



This repository is the v1 public surface for the survey Agent Valve is running. It is README-first: no GitHub Pages site is required for v1.


Published GitHub repository: https://github.com/agent-valve-ai/Agent-Valve-Survey.


The v1 public route is direct Jotform submission. This README documents only the working public Jotform form and cURL submission paths.



## How To Respond



Use either path:



- Browser form: best for humans, browser-capable agents, and quick manual responses.

- Direct Jotform cURL: best for API-capable agents and repeatable automation.



Do not submit passwords, credentials, payment details, private user data, medical information, exact street addresses, private home addresses, or confidential business data.



## Browser Form

Tracked GitHub README browser form link:


~~~text

https://form.jotform.com/261483634936466?tracked_source=github_readme&tracked_medium=github&tracked_campaign=agent_valve_survey_v1&submitted_via=browser_form&survey_version=v1.0

~~~



## Direct Jotform cURL Submission

Direct cURL submit endpoint required by the cURL instructions:

~~~text
https://submit.jotform.com/submit/261483634936466
~~~

Protocol:

- Method: HTTPS POST
- Content type: application/x-www-form-urlencoded
- Auth: no Jotform API key, no admin login, no Authorization header, no browser cookie
- Payload shape: form URL-encoded values
- Success proof: with curl -i -L, the agent receives Jotform's normal HTTP/HTML Thank You response in stdout. Saved/submitted proof is the native Jotform submission record.

Quick use:

1. Copy the complete cURL template below or use examples/direct-jotform-full.sh.
2. Keep the endpoint, content type, formID, simple_spc, and blank website field unchanged.
3. Replace the example answer values with your own non-sensitive answers.
4. For checkbox / multi-select questions, repeat the same answer variable once per selected option.
5. Run the command and check stdout for Jotform's Thank You response.

Required technical and source-tracking fields are included in the cURL examples below. Keep these values present when copying the examples:

- formID=261483634936466
- simple_spc=261483634936466-261483634936466
- website= must remain blank
- survey_version=v1.0
- submitted_via=public_curl
- tracked_source value from the GitHub URL that brought the respondent here, falling back to the GitHub README path

If you arrived here from a community/share link, use the tracked_source value from the GitHub URL that brought you here. Shared GitHub URLs only need tracked_source. The cURL template supplies defaults for tracked_medium, tracked_campaign, and tracked_link_id.

Do not include source-specific launch URLs in public README content, examples, or defaults.

Checkbox/multi-select fields repeat the same answer variable once per selected option:

~~~bash
--data-urlencode "${AGENT_TYPE}[]=OpenClaw agent"
--data-urlencode "${AGENT_TYPE}[]=Claude Code agent"
~~~

Other is a normal selectable option and does not require detail text:

~~~bash
--data-urlencode "${AGENT_TYPE}[]=Other"
~~~

If the respondent wants to add optional details for an Other answer, use [other] with the same answer variable:

~~~bash
--data-urlencode "${AGENT_TYPE}[other]=Custom agent type"
~~~

### Complete Direct Jotform cURL Template

This template includes the current public survey answer fields and resolves the live form inputs before posting.

~~~bash
#!/usr/bin/env bash
set -euo pipefail

FORM_ID="261483634936466"
FORM_URL="https://form.jotform.com/${FORM_ID}"
SUBMIT_URL="https://submit.jotform.com/submit/${FORM_ID}"
REPO_URL="${REPO_URL:-https://github.com/agent-valve-ai/Agent-Valve-Survey?tracked_source=github_readme}"

url_param() {
  local key="$1"
  local query="${REPO_URL#*[?]}"
  query="${query%%#*}"
  printf '%s\n' "$query" | tr '&' '\n' | sed -nE "s/^${key}=//p" | head -n 1
}

TRACKED_SOURCE_VALUE="$(url_param tracked_source)"
TRACKED_MEDIUM_VALUE="$(url_param tracked_medium)"
TRACKED_CAMPAIGN_VALUE="$(url_param tracked_campaign)"
TRACKED_LINK_ID_VALUE="$(url_param tracked_link_id)"

: "${TRACKED_SOURCE_VALUE:=github_readme}"
: "${TRACKED_MEDIUM_VALUE:=github}"
: "${TRACKED_CAMPAIGN_VALUE:=agent_valve_survey_v1}"
: "${TRACKED_LINK_ID_VALUE:=github_readme_direct}"

form_html="$(curl -fsSL "$FORM_URL")"

field_name_nth() {
  local contains="$1"
  local nth="$2"
  local raw
  raw="$(
    printf '%s' "$form_html" |
      grep -oE 'name="[^"]+"' |
      sed -nE 's/name="([^"]+)"/\1/p' |
      grep -F "$contains" |
      sed -n "${nth}p"
  )"
  if [[ -z "$raw" ]]; then
    printf 'Could not locate survey field matching: %s\n' "$contains" >&2
    exit 1
  fi
  printf '%s' "$raw" | sed 's/\[\]$//'
}

field_name() {
  field_name_nth "$1" 1
}

SURVEY_VERSION="$(field_name "survey_version")"
SUBMITTED_VIA="$(field_name "submitted_via")"
TRACKED_SOURCE="$(field_name "tracked_source")"
TRACKED_MEDIUM="$(field_name "tracked_medium")"
TRACKED_CAMPAIGN="$(field_name "tracked_campaign")"
TRACKED_CHANNEL="$(field_name "tracked_channel")"
TRACKED_COMMUNITY="$(field_name "tracked_community")"
TRACKED_LINK_ID="$(field_name "tracked_link_id")"
LANDING_PAGE_URL="$(field_name "landing_page_url")"
AGENT_TYPE="$(field_name "agent_type")"
AGENT_PLATFORM="$(field_name "agent_platform")"
ACTS_ON_BEHALF_OF="$(field_name "acts_on_behalf_of")"
RUNTIME_DEVICE_TYPE="$(field_name "runtime_device_type")"
RELIABLE_ACCESS_METHODS="$(field_name "reliable_access_methods")"
BUSINESS_CONTACT_FREQUENCY="$(field_name "business_contact_frequency")"
AUTONOMY_LEVEL="$(field_name "autonomy_level")"
COMMON_USE_CASES="$(field_name "common_use_cases")"
OTHER_COMMON_USE_CASE="$(field_name "other_common_use_case")"
TOP_COMMON_USE_CASE_1="$(field_name "top_common_use_case_1")"
TOP_COMMON_USE_CASE_2="$(field_name "top_common_use_case_2")"
TOP_COMMON_USE_CASE_3="$(field_name "top_common_use_case_3")"
LLM_MODELS_USED="$(field_name "llm_models_used")"
EXACT_LLM_MODEL_NAMES="$(field_name "exact_llm_model_names")"
OWNER_LOCATIONS="$(field_name "owner_locations")"
OWNER_LOCATION_FLAGS="$(field_name "owner_location_flags")"
TARGET_BUSINESS_LOCATIONS="$(field_name "target_business_locations")"
TARGET_LOCATION_FLAGS="$(field_name "target_location_flags")"
INDUSTRIES_CONTACTED="$(field_name "industries_contacted")"
INDUSTRIES_CONTACT_FREQUENCY="$(field_name "industries_contact_frequency")"
TOP_BOTTLENECK_INDUSTRIES="$(field_name "top_bottleneck_industries")"
SERVICES_TRIED="$(field_name "services_tried")"
SERVICES_TRIED_FREQUENCY="$(field_name "services_tried_frequency")"
GOODS_TRIED="$(field_name "goods_tried")"
GOODS_TRIED_FREQUENCY="$(field_name "goods_tried_frequency")"
PURCHASING_DIFFICULTY_FACTORS="$(field_name "purchasing_difficulty_factors")"
TECHNICAL_ISSUES="$(field_name "technical_issues")"
TOP_BOTTLENECK_REASONS="$(field_name "top_bottleneck_reasons")"
BOTTLENECK_FREQUENCY_OVERALL="$(field_name "bottleneck_frequency_overall")"
BOTTLENECK_FREQUENCY_MATRIX="$(field_name "bottleneck_frequency_matrix")"
SIMPLEST_CONNECTION_METHODS="$(field_name "simplest_connection_methods")"
BEST_CONTACT_CHANNELS="$(field_name "best_contact_channels")"
WORST_CONTACT_CHANNELS="$(field_name "worst_contact_channels")"
DISCOVERABILITY_SEARCH_SOURCES="$(field_name "discoverability_search_sources")"
SEARCH_FIRST_SOURCES="$(field_name "search_first_sources")"
SEARCH_FALLBACK_SOURCES="$(field_name "search_fallback_sources")"
PURCHASE_DECISION_INFLUENCED="$(field_name "purchase_decision_influenced_by_contact_ease")"
SELECTED_DIFFERENT_BUSINESS="$(field_name "selected_different_business_due_to_access")"
PROVIDER_CHOICE_FACTORS="$(field_name "provider_choice_factors")"
AGENT_POLICY_CLARITY="$(field_name "agent_policy_clarity")"
USEFUL_PERMISSION_MODEL="$(field_name "useful_permission_model")"
EASIEST_VERIFICATION_METHODS="$(field_name "easiest_verification_methods")"
SECURITY_SAFETY_BLOCKERS="$(field_name "security_safety_blockers")"
CAUTION_RISK_CONCERNS="$(field_name "caution_risk_concerns")"
SENSITIVE_ACTION_APPROVAL_MODEL="$(field_name "sensitive_action_approval_model")"
BUSINESS_SAFETY_MEASURES="$(field_name "business_safety_measures")"
TASK_SUCCESS_PERCENTAGE="$(field_name "task_success_percentage")"
FAILURE_OUTCOMES="$(field_name "failure_outcomes")"
SUCCESS_RATE_IMPROVEMENTS="$(field_name "success_rate_improvements")"
OVERALL_DIFFICULTY_RATING="$(field_name "overall_difficulty_rating")"
OVERALL_BOTTLENECK_FREQUENCY_RATING="$(field_name "overall_bottleneck_frequency_rating")"
BOTTLENECK_SEVERITY_MATRIX="$(field_name "bottleneck_severity_matrix")"
PRIORITY_INDUSTRY_RANK_1="$(field_name "priority_industry_rank_1")"
PRIORITY_INDUSTRY_RANK_2="$(field_name "priority_industry_rank_2")"
PRIORITY_INDUSTRY_RANK_3="$(field_name "priority_industry_rank_3")"
IMPROVEMENT_POINT_ALLOCATION="$(field_name "improvement_point_allocation")"
AGENT_READY_RATING="$(field_name "agent_ready_rating")"
GREATEST_BOTTLENECK_INDUSTRIES="$(field_name "greatest_bottleneck_industries")"
SERIOUS_BOTTLENECK_INDUSTRY_RANK_1="$(field_name_nth "serious_bottleneck_industry_rank" 1)"
SERIOUS_BOTTLENECK_INDUSTRY_RANK_2="$(field_name_nth "serious_bottleneck_industry_rank" 2)"
SERIOUS_BOTTLENECK_INDUSTRY_RANK_3="$(field_name_nth "serious_bottleneck_industry_rank" 3)"
TOP_RANKED_INDUSTRY_REASON="$(field_name "top_ranked_industry_reason")"
SINGLE_BIGGEST_IMPROVEMENT="$(field_name "single_biggest_improvement")"
SELF_REPORTED_SOURCE="$(field_name "self_reported_source")"
OPEN_COMMENT_ADDITIONAL_USE_CASES="$(field_name "open_comment_additional_use_cases")"
OPEN_COMMENT_FRUSTRATING_SITUATION="$(field_name "open_comment_frustrating_situation")"
OPEN_COMMENT_BUSINESS_CHANGES="$(field_name "open_comment_business_changes")"
OPEN_COMMENT_SURVEY_FEEDBACK="$(field_name "open_comment_survey_feedback")"
FOLLOW_UP_CONSENT="$(field_name "follow_up_consent")"
OPTIONAL_FOLLOW_UP_CONTACT="$(field_name "optional_follow_up_contact")"

curl_args=(
  -i
  -L
  -X
  POST
  "$SUBMIT_URL"
  -H
  "Content-Type: application/x-www-form-urlencoded"

  --data-urlencode "formID=${FORM_ID}"
  --data-urlencode "submitSource=public_curl"
  --data-urlencode "submitDate=undefined"
  --data-urlencode "uploadServerUrl=https://upload.jotform.com/upload"
  --data-urlencode "eventObserver=1"
  --data-urlencode "website="
  --data-urlencode "simple_spc=${FORM_ID}-${FORM_ID}"

  --data-urlencode "${SURVEY_VERSION}=v1.0"
  --data-urlencode "${SUBMITTED_VIA}=public_curl"
  --data-urlencode "${TRACKED_SOURCE}=${TRACKED_SOURCE_VALUE}"
  --data-urlencode "${TRACKED_MEDIUM}=${TRACKED_MEDIUM_VALUE}"
  --data-urlencode "${TRACKED_CAMPAIGN}=${TRACKED_CAMPAIGN_VALUE}"
  --data-urlencode "${TRACKED_CHANNEL}=public_repo"
  --data-urlencode "${TRACKED_COMMUNITY}="
  --data-urlencode "${TRACKED_LINK_ID}=${TRACKED_LINK_ID_VALUE}"
  --data-urlencode "${LANDING_PAGE_URL}=${REPO_URL}"

  --data-urlencode "${AGENT_TYPE}[]=OpenClaw agent"
  --data-urlencode "${AGENT_TYPE}[]=Claude Code agent"
  --data-urlencode "${AGENT_PLATFORM}[]=API calls"
  --data-urlencode "${AGENT_PLATFORM}[]=MCP client"
  --data-urlencode "${AGENT_PLATFORM}[]=MCP server"
  --data-urlencode "${ACTS_ON_BEHALF_OF}[]=User"
  --data-urlencode "${RUNTIME_DEVICE_TYPE}[]=Cloud VPS"
  --data-urlencode "${RUNTIME_DEVICE_TYPE}[]=Windows mini PC"
  --data-urlencode "${RELIABLE_ACCESS_METHODS}[]=Visible web browser"
  --data-urlencode "${RELIABLE_ACCESS_METHODS}[]=HTTP POST / cURL"
  --data-urlencode "${RELIABLE_ACCESS_METHODS}[]=MCP client"
  --data-urlencode "${BUSINESS_CONTACT_FREQUENCY}=Weekly"
  --data-urlencode "${AUTONOMY_LEVEL}=Partial autonomy"
  --data-urlencode "${COMMON_USE_CASES}[]=Appointment scheduling"
  --data-urlencode "${COMMON_USE_CASES}[]=Customer support"
  --data-urlencode "${OTHER_COMMON_USE_CASE}="
  --data-urlencode "${TOP_COMMON_USE_CASE_1}=Appointment scheduling"
  --data-urlencode "${TOP_COMMON_USE_CASE_2}=Customer support"
  --data-urlencode "${TOP_COMMON_USE_CASE_3}=Purchasing or ordering goods"
  --data-urlencode "${LLM_MODELS_USED}[]=OpenAI GPT family"
  --data-urlencode "${LLM_MODELS_USED}[]=Anthropic Claude family"
  --data-urlencode "${EXACT_LLM_MODEL_NAMES}=Example model family/version if known"
  --data-urlencode "${OWNER_LOCATIONS}=Country/region/city or metro only; no exact street address"
  --data-urlencode "${OWNER_LOCATION_FLAGS}[]=One primary location"
  --data-urlencode "${TARGET_BUSINESS_LOCATIONS}=Country/region/city/service area; no private address"
  --data-urlencode "${TARGET_LOCATION_FLAGS}[]=Multiple local areas"
  --data-urlencode "${INDUSTRIES_CONTACTED}[]=Healthcare/HMOs/health plans"
  --data-urlencode "${INDUSTRIES_CONTACTED}[]=Grocery/retail"
  --data-urlencode "${INDUSTRIES_CONTACT_FREQUENCY}=1-2 per week"
  --data-urlencode "${TOP_BOTTLENECK_INDUSTRIES}[]=Healthcare/HMOs/health plans"
  --data-urlencode "${TOP_BOTTLENECK_INDUSTRIES}[]=Grocery/retail"
  --data-urlencode "${SERVICES_TRIED}[]=Appointments"
  --data-urlencode "${SERVICES_TRIED}[]=Customer support"
  --data-urlencode "${SERVICES_TRIED_FREQUENCY}=3-6 per week"
  --data-urlencode "${GOODS_TRIED}[]=Groceries"
  --data-urlencode "${GOODS_TRIED_FREQUENCY}=1-3 per month"
  --data-urlencode "${PURCHASING_DIFFICULTY_FACTORS}[]=Prices"
  --data-urlencode "${PURCHASING_DIFFICULTY_FACTORS}[]=Checkout"
  --data-urlencode "${TECHNICAL_ISSUES}[]=CAPTCHA/human verification"
  --data-urlencode "${TECHNICAL_ISSUES}[]=2FA that the agent cannot complete"
  --data-urlencode "${TECHNICAL_ISSUES}[]=No API/MCP/structured endpoint"
  --data-urlencode "${TOP_BOTTLENECK_REASONS}[]=No structured API/MCP/CLI"
  --data-urlencode "${TOP_BOTTLENECK_REASONS}[]=2FA barriers"
  --data-urlencode "${TOP_BOTTLENECK_REASONS}[]=Phone-only contact"
  --data-urlencode "${BOTTLENECK_FREQUENCY_OVERALL}=Often"
  --data-urlencode "${BOTTLENECK_FREQUENCY_MATRIX}=Example: CAPTCHA often; phone-only sometimes; no API often."
  --data-urlencode "${SIMPLEST_CONNECTION_METHODS}[]=MCP endpoint"
  --data-urlencode "${SIMPLEST_CONNECTION_METHODS}[]=Agent-readable API"
  --data-urlencode "${SIMPLEST_CONNECTION_METHODS}[]=HTTP POST/cURL (form-encoded)"
  --data-urlencode "${SIMPLEST_CONNECTION_METHODS}[]=Agent-friendly form submission"\n  --data-urlencode "${SIMPLEST_CONNECTION_METHODS}[]=Machine-readable status/result updates"
  --data-urlencode "${BEST_CONTACT_CHANNELS}[]=Email"
  --data-urlencode "${BEST_CONTACT_CHANNELS}[]=Structured web form"
  --data-urlencode "${BEST_CONTACT_CHANNELS}[]=HTTP POST/cURL (form-encoded)"
  --data-urlencode "${WORST_CONTACT_CHANNELS}[]=Phone"
  --data-urlencode "${WORST_CONTACT_CHANNELS}[]=Email"
  --data-urlencode "${DISCOVERABILITY_SEARCH_SOURCES}[]=Google Search"
  --data-urlencode "${DISCOVERABILITY_SEARCH_SOURCES}[]=Moltbook community"\n  --data-urlencode "${DISCOVERABILITY_SEARCH_SOURCES}[]=OpenClaw community"
  --data-urlencode "${DISCOVERABILITY_SEARCH_SOURCES}[other]="
  --data-urlencode "${SEARCH_FIRST_SOURCES}[]=Business website"
  --data-urlencode "${SEARCH_FIRST_SOURCES}[]=Search engine"
  --data-urlencode "${SEARCH_FALLBACK_SOURCES}[]=Phone/email"
  --data-urlencode "${PURCHASE_DECISION_INFLUENCED}=Often"
  --data-urlencode "${SELECTED_DIFFERENT_BUSINESS}=Yes sometimes"
  --data-urlencode "${PROVIDER_CHOICE_FACTORS}[]=Easier contact"
  --data-urlencode "${PROVIDER_CHOICE_FACTORS}[]=API support"
  --data-urlencode "${AGENT_POLICY_CLARITY}=Rarely"
  --data-urlencode "${USEFUL_PERMISSION_MODEL}[]=OAuth"
  --data-urlencode "${USEFUL_PERMISSION_MODEL}[]=Delegated auth"
  --data-urlencode "${USEFUL_PERMISSION_MODEL}[]=MCP auth"
  --data-urlencode "${EASIEST_VERIFICATION_METHODS}[]=OAuth"
  --data-urlencode "${EASIEST_VERIFICATION_METHODS}[]=Delegated auth"
  --data-urlencode "${EASIEST_VERIFICATION_METHODS}[]=Email confirmation"
  --data-urlencode "${EASIEST_VERIFICATION_METHODS}[]=SMS confirmation"
  --data-urlencode "${SECURITY_SAFETY_BLOCKERS}[]=CAPTCHA"
  --data-urlencode "${SECURITY_SAFETY_BLOCKERS}[]=2FA that the agent cannot complete"
  --data-urlencode "${SECURITY_SAFETY_BLOCKERS}[other]="
  --data-urlencode "${CAUTION_RISK_CONCERNS}[]=Prompt injection in page content"
  --data-urlencode "${CAUTION_RISK_CONCERNS}[]=Credential leakage"
  --data-urlencode "${CAUTION_RISK_CONCERNS}[]=Concern about connecting payment-card access"
  --data-urlencode "${CAUTION_RISK_CONCERNS}[]=Concern about connecting bank-account access"
  --data-urlencode "${CAUTION_RISK_CONCERNS}[]=Concern about connecting email-account access"
  --data-urlencode "${CAUTION_RISK_CONCERNS}[]=Concern about connecting business account access"
  --data-urlencode "${CAUTION_RISK_CONCERNS}[]=Do not trust the company requesting access"
  --data-urlencode "${CAUTION_RISK_CONCERNS}[]=Do not understand why the requested access is needed"
  --data-urlencode "${CAUTION_RISK_CONCERNS}[]=Fear of unexpected charges"
  --data-urlencode "${CAUTION_RISK_CONCERNS}[]=Prefer manual entry for sensitive data"
  --data-urlencode "${CAUTION_RISK_CONCERNS}[other]="
  --data-urlencode "${SENSITIVE_ACTION_APPROVAL_MODEL}[]=User confirmation before purchases"
  --data-urlencode "${SENSITIVE_ACTION_APPROVAL_MODEL}[]=Signed request"
  --data-urlencode "${SENSITIVE_ACTION_APPROVAL_MODEL}[]=Verified account"
  --data-urlencode "${SENSITIVE_ACTION_APPROVAL_MODEL}[]=Agent registry"
  --data-urlencode "${SENSITIVE_ACTION_APPROVAL_MODEL}[other]="
  --data-urlencode "${BUSINESS_SAFETY_MEASURES}[]=Delegated auth with scoped permissions"
  --data-urlencode "${BUSINESS_SAFETY_MEASURES}[]=Prompt-injection-resistant APIs"
  --data-urlencode "${BUSINESS_SAFETY_MEASURES}[]=Agent registry"
  --data-urlencode "${BUSINESS_SAFETY_MEASURES}[other]="
  --data-urlencode "${TASK_SUCCESS_PERCENTAGE}=41-60"
  --data-urlencode "${FAILURE_OUTCOMES}[]=Human handoff"
  --data-urlencode "${FAILURE_OUTCOMES}[]=Different provider"
  --data-urlencode "${SUCCESS_RATE_IMPROVEMENTS}[]=MCP support"
  --data-urlencode "${SUCCESS_RATE_IMPROVEMENTS}[]=APIs"
  --data-urlencode "${OVERALL_DIFFICULTY_RATING}=4"
  --data-urlencode "${OVERALL_BOTTLENECK_FREQUENCY_RATING}=4"
  --data-urlencode "${BOTTLENECK_SEVERITY_MATRIX}=Example: no structured endpoint 5; CAPTCHA 4; slow response 3."
  --data-urlencode "${PRIORITY_INDUSTRY_RANK_1}=Healthcare/HMOs/health plans"
  --data-urlencode "${PRIORITY_INDUSTRY_RANK_2}=Government/public services"
  --data-urlencode "${PRIORITY_INDUSTRY_RANK_3}=Grocery/retail"
  --data-urlencode "${IMPROVEMENT_POINT_ALLOCATION}=MCP/API/CLI 35; better discovery 15; booking/checkout 20; reliability 10; trust/verification 10; stronger model/more context 10."
  --data-urlencode "${AGENT_READY_RATING}=2"
  --data-urlencode "${GREATEST_BOTTLENECK_INDUSTRIES}[]=Healthcare/HMOs/health plans"
  --data-urlencode "${GREATEST_BOTTLENECK_INDUSTRIES}[]=Government/public services"
  --data-urlencode "${SERIOUS_BOTTLENECK_INDUSTRY_RANK_1}=Healthcare/HMOs/health plans"
  --data-urlencode "${SERIOUS_BOTTLENECK_INDUSTRY_RANK_2}=Government/public services"
  --data-urlencode "${SERIOUS_BOTTLENECK_INDUSTRY_RANK_3}=Grocery/retail"
  --data-urlencode "${TOP_RANKED_INDUSTRY_REASON}[]=No structured API/MCP/CLI"
  --data-urlencode "${TOP_RANKED_INDUSTRY_REASON}[]=CAPTCHA/human-only verification"
  --d…255 tokens truncated… format |

| --- | --- | --- |

| Agent type(s) | Yes | Choose all that apply. OpenClaw agent; NanoClaw agent; Hermes Agent; Claude agent; Claude Code agent; Google Spark / Gemini-style agent; Lindy agent; Make agent/workflow; Zapier agent/workflow; n8n AI agent or workflow agent; Browser automation agent; Desktop automation agent; Mobile automation agent; API/workflow agent; Voice/phone agent; Research agent; Coding agent; Operations/admin agent; Other Claw/similar agent product; Other; Unable to determine |
| Main operating environment | No | Choose all that apply. Browser automation; Mobile automation; Desktop automation; API calls; MCP client; MCP server; CLI; Workflow automation; Email; Calendar; Voice; Phone; Chat; CRM; Marketplace; Internal system; Local; Cloud; Hybrid; Other; Unable to determine |
| Who does the agent act on behalf of? | No | Choose all that apply. User; Operator; Organization; Customer; Internal team; Other; Unable to determine |
| Runtime device or hosting type | No | Choose all that apply. Cloud VPS; Cloud server; Dedicated remote server; Mac mini; Mac laptop; Mac desktop; Windows mini PC; Windows NUC; Windows laptop; Windows desktop; Linux mini PC; Linux NUC; Linux laptop; Linux desktop; iPhone; iPad; Android phone; Android tablet; Managed agent platform hosted by someone else; I do not know; My operator manages this; Other; Unable to determine |
| Reliable access methods | No | Choose all that apply. Visible web browser; Headless browser automation; HTTP POST / cURL; Public API; MCP server; MCP client; CLI / shell commands; Email; Chat; Messaging apps; Phone calls; Voice calls; Logged-in sessions provided by an operator; Cookies provided by an operator; OAuth; Delegated login; File upload; File download; Payment flow; Checkout flow; Calendar flow; Booking flow; Form filling; Screen/desktop automation; Mobile app automation; Human/operator handoff; Other; Unable to determine |
| How often does the agent contact businesses? | No | Daily; Weekly; Monthly; Rarely; Never; Unable to determine |
| Level of autonomy | No | Human-guided; Partial autonomy; High autonomy; Fully autonomous within policy; Unable to determine |
| Most common use cases | Yes | Choose all that apply. Appointment scheduling; Customer support; Purchasing or ordering goods; Grocery shopping; Coffee/beverage/pantry/household replenishment; Quotes/pricing; Booking travel or local services; Healthcare/HMO/member services; Home maintenance and repair; Beauty/wellness appointments; Research/comparison shopping; Lead generation/outreach; Government or compliance tasks; Other; Unable to determine |
| Other use case(s), please describe | No | Free text |
| Top common use case 1 | No | Free text |
| Top common use case 2 | No | Free text |
| Top common use case 3 | No | Free text |
| LLM model families used | Yes | Choose all that apply. OpenAI GPT family; Anthropic Claude family; Google Gemini family; Meta Llama family; Mistral/Mixtral; Qwen; DeepSeek; xAI Grok; Nous Hermes; Cohere Command; Hosted/proprietary model; Local/open-weight model; Fine-tuned model; Router/ensemble; Varies by task; Other; Unable to determine |
| Exact model names/versions if known | No | Free text |
| Where is the agent owner/operator based? | Yes | Country, state/region, city/metro, or global/distributed. No exact street or private home address. |
| Owner/operator location type | No | Choose all that apply. One primary location; Multiple locations; Global/distributed; Intentionally not disclosed; Unable to determine |
| Where are the target businesses/services located? | Yes | Country, state/region, city/metro, service area, online/global, or varies by task. No exact private address. |
| How does the target business location compare with the owner/operator location? | No | Choose all that apply. Same as owner; Different from owner; Multiple local areas; Multiple countries; Online/global; Cross-border; Varies by task; Unable to determine |
| Business categories contacted | No | Choose all that apply. Frequency is asked immediately below. Healthcare/HMOs/health plans; Healthcare providers/clinics; Government/public services; Banking/insurance; Telecom/utilities; Grocery/retail; Restaurants/cafes; Travel/hospitality; Home maintenance/repair; Beauty/wellness/fitness; Education/training; Real estate/property; Legal/accounting/professional services; E-commerce/marketplaces; Software/SaaS; Logistics/delivery; Automotive; Other; Unable to determine |
| For the business categories you selected above, how often does the agent usually contact them? | No | 3+ per day; 1-2 per day; 3-6 per week; 1-2 per week; 1-3 per month; Less than monthly; Varies a lot by task; Unable to determine |
| Categories hardest to contact | Yes | Choose all that apply. Healthcare/HMOs/health plans; Healthcare providers/clinics; Government/public services; Banking/insurance; Telecom/utilities; Grocery/retail; Restaurants/cafes; Travel/hospitality; Home maintenance/repair; Beauty/wellness/fitness; Education/training; Real estate/property; Legal/accounting/professional services; E-commerce/marketplaces; Software/SaaS; Logistics/delivery; Automotive; Other; Unable to determine |
| Services agents try to access | No | Choose all that apply. Frequency is asked immediately below. Appointments; Reservations; Quotes; Customer support; Account changes; Eligibility/coverage check; Order status; Delivery scheduling; Repairs/maintenance; Returns/refunds; Procurement; Compliance paperwork; Other; Unable to determine |
| For the services you selected above, how often does the agent usually try to access them? | No | 3+ per day; 1-2 per day; 3-6 per week; 1-2 per week; 1-3 per month; Less than monthly; Varies a lot by task; Unable to determine |
| Goods agents find, compare, or purchase | No | Choose all that apply. Frequency is asked immediately below. Groceries; Coffee/beverage/pantry/household replenishment; Office supplies; Electronics; Software/subscriptions; Medical/pharmacy items; Home repair parts; Beauty/wellness products; Travel tickets; Other; Unable to determine |
| For the goods you selected above, how often does the agent usually find, compare, or purchase them? | No | 3+ per day; 1-2 per day; 3-6 per week; 1-2 per week; 1-3 per month; Less than monthly; Varies a lot by task; Unable to determine |
| Where purchasing gets difficult | No | Choose all that apply. Specs; Prices; Inventory; Delivery; Shipping; Returns; Bulk pricing; Quotes; Checkout; Tax-exempt purchasing; Payment authorization; Compatibility; Reviews; Outdated listings; Seller contact; Local stock; Other |
| Technical issues/failure modes | No | Choose all that apply. CAPTCHA/human verification; Login that the agent cannot complete; 2FA that the agent cannot complete; Blocked automation; No API/MCP/structured endpoint; Broken forms; Unclear contact path; Phone-only workflow; Email-only workflow; Dynamic pages; Rate limiting; Unsupported file upload; Payment challenge; Ambiguous data; Outdated data; Other; Unable to determine |
| Biggest bottlenecks | No | Choose all that apply. No structured API/MCP/CLI; CAPTCHA/human-only verification; Login barriers; 2FA barriers; Payment barriers; Phone-only contact; Unclear business hours; Unclear availability/pricing; Unstructured websites; Poor search/discovery; Slow human response; Policy does not mention agents; Forms break under automation; Other; Unable to determine |
| Overall bottleneck frequency | Yes | Almost every attempt; Often; Sometimes; Rarely; Almost never; Never; Not applicable; Unable to determine |
| Frequency by bottleneck type (free-text or structured summary) | No | Free text or structured summary |
| Simplest ways to connect | Yes | Choose all that apply. MCP server; MCP endpoint; Public API; Agent-readable API; Agent-specific API; HTTP POST/cURL (form-encoded); Programmatic form submission; Agent-friendly form submission; CLI; SDK; OpenAPI spec; Structured web form; Clear agent-access page; Email; Live chat; Messaging; Machine-readable data; Machine-readable status/result updates; Marketplace; Booking portal; Procurement portal; Standardized contact page; Directory; Webhook; Voice/phone for agents; Verified gateway; Delegation/human handoff; Other - please specify (optional); Unable to determine |
| Contact channels working best today | No | Choose all that apply. MCP server; Public API; Agent-specific API; HTTP POST/cURL (form-encoded); Programmatic form submission; CLI; SDK; Structured web form; Email; Live chat; Messaging; Phone; Booking portal; Marketplace; Directory; Webhook; Human handoff; Other; Unable to determine |
| Contact channels working worst today | No | Choose all that apply. MCP server; Public API; Agent-specific API; HTTP POST/cURL (form-encoded); Programmatic form submission; CLI; SDK; Structured web form; Email; Live chat; Messaging; Phone; Booking portal; Marketplace; Directory; Webhook; Human handoff; Other; Unable to determine |
| Where do you search to find products, services, or businesses that an AI agent can access or use? | No | Choose all that apply. Google Search; Other general web search engine; Google Maps; Apple Maps; Other local/maps search; Official business website; Official accessibility statement page; Official agent-access page; API documentation; Knowledge base/help center; ClawHub registry; MCP registry; MCP community; Moltbook community; OpenClaw community; Accessibility-specific directory; Government/public registry; App/plugin marketplace; Business directory; Review site; Product/vendor community; GitHub Discussions; GitHub Issues; Discord; Slack community; Matrix community; Stack Overflow; Hacker News; Reddit; Instagram; Facebook; LinkedIn; X/Twitter; YouTube; TikTok; User/operator-provided link; Email history; CRM/internal records; Other; Unable to determine |
| Where agents search first | No | Choose all that apply. Business website; Search engine; Maps/local search; Marketplace/directory; Social profile; API docs; MCP registry; Knowledge base; User-provided link; Email history; CRM/internal data; Other; Unable to determine |
| Where agents search if first source is not enough | No | Choose all that apply. Business website; Search engine; Maps/local search; Marketplace/directory; Social profile; API docs; MCP registry; Knowledge base; Phone/email; User asks human; Other; Unable to determine |
| How often ease of contact influences choice | No | Always; Often; Sometimes; Rarely; Never; Unable to determine |
| Have you ever chosen a different business/provider because the preferred one was too hard for an agent to contact, book, buy from, or use? | No | Yes often; Yes sometimes; Yes once; No; Unable to determine |
| Factors causing one business to be chosen | No | Choose all that apply. Easier contact; MCP support; API support; CLI/SDK support; Clear booking/checkout; Clear pricing; Availability; Faster response; Structured data; Reliable website; Reviews; Price; Location; Timing; User preference; Human approval; Other |
| Do businesses make AI-agent permissions clear? | No | Yes often; Sometimes; Rarely; No; Unable to determine |
| Most useful permission model | No | Choose all that apply. API key; OAuth; Delegated auth; MCP auth; Signed request; Verified account; User login permission; Email confirmation; SMS confirmation; Payment confirmation; Human confirmation; Certificate; Agent registry; Service account; Other |
| Verification methods easiest to support | No | Choose all that apply. API key; OAuth; Delegated auth; MCP auth; Signed request; Verified account; User login permission; Email confirmation; SMS confirmation; Payment confirmation; Human confirmation; Certificate; Agent registry; Service account; Other |
| Security and safety controls that block access | No | Choose all that apply. CAPTCHA; Anti-bot checks; Login that the agent cannot complete; 2FA that the agent cannot complete; Requirement to share user credentials; Requirement to store user credentials; No delegated auth option; No OAuth option; No scoped permission option; Payment authorization requirements; Human approval is required but no clear flow exists; Rate limits that block normal tasks; Fraud checks that block normal tasks; Business policy says agents are not allowed; Agent identity requirements are unclear; Agent verification requirements are unclear; Security warnings; Blocked browser automation; Blocked APIs; Other; optional Other detail via [other] / Other - please specify; Unable to determine |
| Agent and operator caution and risk concerns | No | Choose all that apply. Prompt injection in page content; Malicious instructions in page content; Credential leakage; Sensitive data exposure; Sensitive data extraction; Unsafe tool execution; Unauthorized purchase; Unauthorized booking; Unauthorized cancellation; Unauthorized account change; Unclear authority; Unclear user consent; Payment risk; Overcharging; Refund risk; Dispute risk; Compliance risk; Legal risk; Reputational risk from a mistaken agent action; Malicious website; Compromised website; Spoofed website; Unreliable website; Unclear data retention practices; Unclear privacy practices; No audit trail; No confirmation record; Concern about connecting payment-card access; Concern about connecting bank-account access; Concern about connecting email-account access; Concern about connecting business account access; Do not trust the company requesting access; Do not understand why the requested access is needed; Fear of unexpected charges; Prefer manual entry for sensitive data; Other; Unable to determine |
| Approval model you would use or feel comfortable with for sensitive actions | No | Choose all that apply. User confirmation before purchases; User confirmation before payments; User confirmation before booking; User confirmation before cancellation; User confirmation before account changes; User confirmation before sending sensitive personal data; User confirmation before sending sensitive business data; Pre-approved spending limit; Policy-based budget; Scoped permissions for specific task types; Read-only mode before final submission; Quote-first mode before final submission; Draft-first mode before final submission; Reversible action; Cancellation window; Human handoff for ambiguous cases; Human handoff for high-risk cases; Signed request; Verified account; Agent registry; Audit log after action; Receipt after action; Confirmation message after action; Other; optional Other detail via [other] / Other - please specify; Unable to determine |
| Safety measures businesses should provide | No | Choose all that apply. Delegated auth with scoped permissions; OAuth with scoped permissions; No need to share raw user credentials with the agent; Clear AI-agent access policy; Clear consent screen showing what the agent can do; Data minimization; Redaction of unnecessary sensitive data; Prompt-injection-resistant pages; Prompt-injection-resistant APIs; Machine-readable task data; Verified agent gateway; Signed requests; Agent registry; Safe sandbox; Dry-run mode; Quote-first mode; Draft-first mode; Payment limits; Purchase confirmation; Refund path; Dispute path; Audit logs; Receipts; Action history; Rate limits that protect the business without blocking legitimate agents; Human escalation; Support handoff; Security contact; Abuse-reporting path; Clear compliance terms for agent access; Clear legal terms for agent access; Other; optional Other detail via [other] / Other - please specify; Unable to determine |
| Percentage of tasks usually completed successfully | No | 0-20; 21-40; 41-60; 61-80; 81-100; Unable to determine |
| When it fails, what usually happens? | No | Choose all that apply. Abandon task; Human handoff; Retries; Different provider; Phone call; Email; Support ticket; User decision needed; Other; Unable to determine |
| What would improve success rate? | No | Choose all that apply. Standardized contact data; MCP support; APIs; CLI/SDK; Clear policies; Structured websites; Fewer CAPTCHA barriers for verified agents; Better routing; Faster response; Machine-readable data; Real-time availability/pricing; Booking protocol; Quote format; Auth/permission model; Tracking; Human handoff; Stronger/better model; Larger context window / more tokens; Better tool/browser reliability; Other |
| Overall difficulty connecting with businesses | No | 1 easy; 2; 3; 4; 5 very difficult; Unable to determine |
| Overall frequency of preventing/delaying bottlenecks | No | 1 never; 2; 3; 4; 5 almost always; Unable to determine |
| Severity by bottleneck type (free-text or structured summary) | No | Free text or structured summary |
| Priority industry rank 1 | No | Free text |
| Priority industry rank 2 | No | Free text |
| Priority industry rank 3 | No | Free text |
| Divide 100 points across improvement areas based on how much each would improve agent success | No | The total should equal 100. Give more points to the changes that would help the most. Example: MCP/API 35; better discovery 15; booking/checkout 20; reliability 10; trust/verification 10; stronger model/more context 10. |
| How AI-agent-ready are businesses today? | No | 1 not ready; 2; 3; 4; 5 very ready; Unable to determine |
| Industries with the greatest contact/access bottlenecks | No | Choose all that apply. Healthcare/HMOs/health plans; Healthcare providers/clinics; Government/public services; Banking/insurance; Telecom/utilities; Grocery/retail; Restaurants/cafes; Travel/hospitality; Home maintenance/repair; Beauty/wellness/fitness; Education/training; Real estate/property; Legal/accounting/professional services; E-commerce/marketplaces; Software/SaaS; Logistics/delivery; Automotive; Other; Unable to determine |
| Most serious bottleneck industry - rank 1 | No | Free text |
| Most serious bottleneck industry - rank 2 | No | Free text |
| Most serious bottleneck industry - rank 3 | No | Free text |
| Main reason the top-ranked industry is difficult | No | Choose all that apply. No structured API/MCP/CLI; CAPTCHA/human-only verification; Login barriers; 2FA barriers; Payment barriers; Phone-only contact; Unclear availability/pricing; Unstructured websites; Slow human response; Agent policy unclear; Other; Unable to determine |
| Single biggest improvement businesses or platforms could make for agent success | Yes | MCP server support; Public API; Agent-specific API; OpenAPI/structured docs; Standardized contact page; Machine-readable business data; Verified-agent gateway; Better booking/checkout flow; Clear AI-agent permission policy; Human handoff route; Other; Unable to determine |
| Where did you find this survey? | No | GitHub; Hacker News; Reddit; Discord; X/Twitter; LinkedIn; Newsletter/email; Search engine; Direct link; My operator; Shared by another agent/operator; Other; Unable to determine. Use Other if you want to add the exact community, post, person, or URL. |
| Additional use cases/workflows | No | Free text |
| Common or frustrating situation | No | Free text |
| What should businesses/platforms change? | No | Free text |
| Additional survey comments | No | Free text |
| Would you like to leave contact details so we can follow up and send you the report? | Yes | Yes; No |
| Contact details | No | Free text: contact details only |
## Examples



- [Full direct Jotform cURL request](examples/direct-jotform-full.sh)

- [Minimal direct Jotform cURL request](examples/curl-valid-minimal.sh)



## Data Use Notes



- The survey is for aggregate research about agent-to-business access bottlenecks.

- Responses may be analyzed by industry, region, agent type, model family, access path, and recurring failure mode.

- Survey answers are anonymous.

- Optional follow-up contact is not required and is separate from the survey.

- Optional follow-up contact would be stored separately from normal anonymous survey analytics where the platform allows it.

- Do not include secrets or sensitive third-party data in survey responses.
\n


