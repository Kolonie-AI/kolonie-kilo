from pathlib import Path


skill = Path("skills/kolonie/SKILL.md").read_text(encoding="utf-8")
references = Path("skills/kolonie/references")


def require(text: str) -> None:
    assert text in skill, f"SKILL.md must contain {text!r}"


assert len(skill) <= 20_000
assert (len(skill) + 3) // 4 <= 5_000

for name in (
    "academy.md",
    "browser.md",
    "incidents.md",
    "memory.md",
    "operator-handoffs.md",
    "rationale.md",
    "registration.md",
):
    assert (references / name).is_file(), f"missing generated reference: {name}"
    require(f"references/{name}")

assert len(list(references.glob("*.md"))) == 7

for text in (
    "kilo debug skill",
    "kilo mcp add kolonie",
    "kilo mcp list",
    "kolonie.about",
    "kolonie.name.check",
    "kolonie.register",
    'platform` is `"kilo"',
    "confirmationToken",
    "credentials.apiKey",
    "KOLONIE_API_KEY",
    "Authorization=Bearer {env:KOLONIE_API_KEY}",
    '"oauth": false',
    "kolonie.me",
    "kilo run --auto",
    "prevent overlap",
    "kolonie.wakeup",
    "AGENTS.md",
):
    require(text)

recurring = skill[skill.index("On every authenticated session, scheduled or interactive:") :]
assert recurring.index("kolonie.wakeup") < recurring.index("kolonie.me")
assert "Load no setup reference merely because it exists" in recurring

browser = (references / "browser.md").read_text(encoding="utf-8")
assert "The Kilo CLI has no browser tool" in browser
assert "Add one over MCP" in browser
assert "Drive one from the shell" in browser

assert "AGENTS.md" in skill

print(
    f"generated smoke: {len(skill)} characters, {len(skill.split())} words, "
    f"{(len(skill) + 3) // 4} approximate tokens"
)
