#!/usr/bin/env bash
set -euo pipefail

# Pass a source-specific GitHub URL via REPO_URL or as the first argument.
# The public launch URL should carry tracked_source only and no section anchor.

FORM_ID="261483634936466"
FORM_URL="https://form.jotform.com/${FORM_ID}"
SUBMIT_URL="https://submit.jotform.com/submit/${FORM_ID}"
REPO_URL="${REPO_URL:-${1:-https://github.com/agent-valve-ai/Agent-Valve-Survey?tracked_source=github_readme}}"

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

field_name() {
  local contains="$1"
  local raw
  raw="$(
    printf '%s' "$form_html" |
      grep -oE 'name="[^"]+"' |
      sed -nE 's/name="([^"]+)"/\1/p' |
      grep -F "$contains" |
      head -n 1
  )"
  if [[ -z "$raw" ]]; then
    printf 'Could not locate survey field matching: %s\n' "$contains" >&2
    exit 1
  fi
  printf '%s' "$raw" | sed 's/\[\]$//'
}

SURVEY_VERSION="$(field_name "survey_version")"
SUBMITTED_VIA="$(field_name "submitted_via")"
TRACKED_SOURCE="$(field_name "tracked_source")"
TRACKED_MEDIUM="$(field_name "tracked_medium")"
TRACKED_CAMPAIGN="$(field_name "tracked_campaign")"
TRACKED_LINK_ID="$(field_name "tracked_link_id")"
LANDING_PAGE_URL="$(field_name "landing_page_url")"
AGENT_TYPE="$(field_name "agent_type")"
COMMON_USE_CASES="$(field_name "common_use_cases")"
OTHER_COMMON_USE_CASE="$(field_name "other_common_use_case")"
LLM_MODELS_USED="$(field_name "llm_models_used")"
OWNER_LOCATIONS="$(field_name "owner_locations")"
TARGET_BUSINESS_LOCATIONS="$(field_name "target_business_locations")"
TOP_BOTTLENECK_INDUSTRIES="$(field_name "top_bottleneck_industries")"
BOTTLENECK_FREQUENCY_OVERALL="$(field_name "bottleneck_frequency_overall")"
SIMPLEST_CONNECTION_METHODS="$(field_name "simplest_connection_methods")"
DISCOVERABILITY_SEARCH_SOURCES="$(field_name "discoverability_search_sources")"
SECURITY_SAFETY_BLOCKERS="$(field_name "security_safety_blockers")"
CAUTION_RISK_CONCERNS="$(field_name "caution_risk_concerns")"
SENSITIVE_ACTION_APPROVAL_MODEL="$(field_name "sensitive_action_approval_model")"
BUSINESS_SAFETY_MEASURES="$(field_name "business_safety_measures")"
SINGLE_BIGGEST_IMPROVEMENT="$(field_name "single_biggest_improvement")"
FOLLOW_UP_CONSENT="$(field_name "follow_up_consent")"
OPTIONAL_FOLLOW_UP_CONTACT="$(field_name "optional_follow_up_contact")"

curl -i -L -X POST "$SUBMIT_URL" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "formID=${FORM_ID}" \
  --data-urlencode "simple_spc=${FORM_ID}-${FORM_ID}" \
  --data-urlencode "website=" \
  --data-urlencode "${SURVEY_VERSION}=v1.0" \
  --data-urlencode "${SUBMITTED_VIA}=public_curl" \
  --data-urlencode "${TRACKED_SOURCE}=${TRACKED_SOURCE_VALUE}" \
  --data-urlencode "${TRACKED_MEDIUM}=${TRACKED_MEDIUM_VALUE}" \
  --data-urlencode "${TRACKED_CAMPAIGN}=${TRACKED_CAMPAIGN_VALUE}" \
  --data-urlencode "${TRACKED_LINK_ID}=${TRACKED_LINK_ID_VALUE}" \
  --data-urlencode "${LANDING_PAGE_URL}=${REPO_URL}" \
  --data-urlencode "${AGENT_TYPE}[]=OpenClaw agent" \
  --data-urlencode "${AGENT_TYPE}[]=Claude Code agent" \
  --data-urlencode "${COMMON_USE_CASES}[]=Appointment scheduling" \
  --data-urlencode "${OTHER_COMMON_USE_CASE}=" \
  --data-urlencode "${LLM_MODELS_USED}[]=OpenAI GPT family" \
  --data-urlencode "${OWNER_LOCATIONS}=Country/region/city if known" \
  --data-urlencode "${TARGET_BUSINESS_LOCATIONS}=Country/region/city/service area" \
  --data-urlencode "${TOP_BOTTLENECK_INDUSTRIES}[]=Healthcare/HMOs/health plans" \
  --data-urlencode "${BOTTLENECK_FREQUENCY_OVERALL}=Often" \
  --data-urlencode "${SIMPLEST_CONNECTION_METHODS}[]=MCP endpoint" \
  --data-urlencode "${SIMPLEST_CONNECTION_METHODS}[]=HTTP POST/cURL (form-encoded)" \
  --data-urlencode "${DISCOVERABILITY_SEARCH_SOURCES}[]=Google Search" \
  --data-urlencode "${DISCOVERABILITY_SEARCH_SOURCES}[other]=" \
  --data-urlencode "${SECURITY_SAFETY_BLOCKERS}[]=CAPTCHA" \
  --data-urlencode "${SECURITY_SAFETY_BLOCKERS}[other]=" \
  --data-urlencode "${CAUTION_RISK_CONCERNS}[]=Credential leakage" \
  --data-urlencode "${CAUTION_RISK_CONCERNS}[]=Concern about connecting payment-card access" \
  --data-urlencode "${CAUTION_RISK_CONCERNS}[]=Prefer manual entry for sensitive data" \
  --data-urlencode "${CAUTION_RISK_CONCERNS}[other]=" \
  --data-urlencode "${SENSITIVE_ACTION_APPROVAL_MODEL}[]=User confirmation before purchases" \
  --data-urlencode "${SENSITIVE_ACTION_APPROVAL_MODEL}[other]=" \
  --data-urlencode "${BUSINESS_SAFETY_MEASURES}[]=Delegated auth with scoped permissions" \
  --data-urlencode "${BUSINESS_SAFETY_MEASURES}[other]=" \
  --data-urlencode "${SINGLE_BIGGEST_IMPROVEMENT}=MCP server support" \
  --data-urlencode "${FOLLOW_UP_CONSENT}=Yes" \
  --data-urlencode "${OPTIONAL_FOLLOW_UP_CONTACT}=example@gmail.com"
