#!/usr/bin/env bash
set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "ERROR: run changelog.sh inside a Git repository." >&2
  exit 2
fi

last_tag="$(git describe --tags --abbrev=0 2>/dev/null || true)"
if [[ -n "$last_tag" ]]; then
  range="${last_tag}..HEAD"
  baseline="$last_tag"
else
  range="HEAD"
  baseline="repository start (no tags found)"
fi

added=()
fixed=()
changed=()
removed=()

while IFS= read -r subject; do
  [[ -z "$subject" ]] && continue
  lower="${subject,,}"
  case "$lower" in
    feat:*|feature:*) added+=("$subject") ;;
    fix:*|bugfix:*) fixed+=("$subject") ;;
    remove:*|removed:*|delete:*|deleted:*) removed+=("$subject") ;;
    *) changed+=("$subject") ;;
  esac
done < <(git log "$range" --no-merges --reverse --pretty=tformat:'%s')

write_section() {
  local heading="$1"
  shift
  printf '### %s
' "$heading"
  if (($# == 0)); then
    printf '%s
' '- None'
  else
    local item
    for item in "$@"; do
      printf -- '- %s
' "$item"
    done
  fi
  printf '
'
}

{
  printf '%s

' '## [Unreleased]'
  printf '<!-- Generated from commits after: %s -->

' "$baseline"
  write_section 'Added' "${added[@]}"
  write_section 'Fixed' "${fixed[@]}"
  write_section 'Changed' "${changed[@]}"
  write_section 'Removed' "${removed[@]}"
} > CHANGELOG.md

printf 'Generated CHANGELOG.md from commits after %s.
' "$baseline"
