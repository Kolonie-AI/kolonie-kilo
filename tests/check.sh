#!/usr/bin/env bash
set -euo pipefail

docs=${KOLONIE_DOCS_DIR:-.kolonie-docs}
if [[ ! -f "$docs/.github/scripts/build-skill.py" ]]; then
  echo "KOLONIE_DOCS_DIR must name a current kolonie-docs checkout" >&2
  exit 1
fi

python3 "$docs/.github/tests/build-skill.test.py"
python3 "$docs/.github/scripts/build-skill.py" \
  "$docs/onboarding/skill/body.md" \
  skill.runtime.md \
  skills/kolonie/SKILL.md \
  --check
python3 tests/test_generated.py

python3 - <<'PY'
import re
import urllib.request
from pathlib import Path

source = urllib.request.urlopen(
    "https://raw.githubusercontent.com/Kilo-Org/kilocode/main/packages/opencode/src/cli/cmd/mcp.ts"
).read().decode()
commands = set(re.findall(r'command:\s*"([a-z-]+)', source))
required = {"add", "list"}
assert required <= commands, f"missing Kilo MCP commands: {sorted(required - commands)}"

run = urllib.request.urlopen(
    "https://raw.githubusercontent.com/Kilo-Org/kilocode/main/packages/opencode/src/cli/cmd/run.ts"
).read().decode()
assert 'command: "run [message..]"' in run
assert '.option("auto"' in run

debug = urllib.request.urlopen(
    "https://raw.githubusercontent.com/Kilo-Org/kilocode/main/packages/opencode/src/cli/cmd/debug/skill.ts"
).read().decode()
assert 'command: "skill"' in debug

skill = Path("skills/kolonie/SKILL.md").read_text(encoding="utf-8")
assert "kilo mcp remove" not in skill
print("Kilo source check: debug skill, mcp add/list, and run --auto exist")
PY

install_root=$(mktemp -d)
trap 'rm -rf "$install_root"' EXIT
mkdir -p "$install_root/.kilo/skills"
cp -R skills/kolonie "$install_root/.kilo/skills/kolonie"
cmp skills/kolonie/SKILL.md "$install_root/.kilo/skills/kolonie/SKILL.md"
for reference in skills/kolonie/references/*.md; do
  cmp "$reference" "$install_root/.kilo/skills/kolonie/references/${reference##*/}"
done
[[ $(find "$install_root/.kilo/skills/kolonie/references" -maxdepth 1 -type f -name '*.md' | wc -l) -eq 7 ]]

echo "scratch install: complete skill directory copied; Kilo executable unavailable"
