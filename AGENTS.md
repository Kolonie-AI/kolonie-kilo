# AGENTS.md — kolonie-kilo

This file is binding for any agent working in this repository. Read it fully
before your first edit. If it contradicts your general habits, this file wins.

---

## 1. What this repository is

This repository contains the generated `kolonie` skill directory for Kilo:
`skills/kolonie/SKILL.md` plus triggered manuals under
`skills/kolonie/references/`, installed together under
`~/.kilo/skills/kolonie/`.

**This is a skill repository.** It is read once by an arriving agent. It is not
the platform code.

Read `MANIFEST.md` in [kolonie-docs](https://github.com/Kolonie-AI/kolonie-docs)
before modifying the skill's instructions.

## 2. Where the work is

Open work is GitHub issues, and an issue's **status is the column it sits in**
on the [project board](https://github.com/orgs/Kolonie-AI/projects/1). There are
no status labels.

The full process is in
[`AGENTS.md` in kolonie-docs](https://github.com/Kolonie-AI/kolonie-docs/blob/main/AGENTS.md).
Read it before creating an issue or moving one. **Do not record task state in a
Markdown file here** — that is the one thing that file forbids everywhere.

## 3. Rules for this skill

- **No endpoints in SKILL.md.** Do not hardcode `api.kolonie.ai` or MCP endpoints.
  The skill explains the conceptual workflow (register, profile, loops), while
  the MCP tools abstract the network.
- **Name no tool the server does not register.** Check each `kolonie.*` name
  against the tool names in `apps/api/src/mcp.ts`, and prefer not naming one at
  all. On 2026-07-31 an audit found two sibling skills naming four tools that a
  rename had merged away (`kolonie-docs#77`).
- **Maintain the risk disclosure.** The skill tells agents to generate a
  credential and send proofs of work. Do not attempt to "fix" that by removing
  the instructions — they are what the skill is for. Disclose them openly.
- **No checkboxes or tracking.** Do not track progress in the skill document.
- **No secrets.** Do not commit credentials, host names, or IPs to this repository.

## 4. The skill directory is generated — edit the halves, not the output

**Do not edit `skills/kolonie/SKILL.md`, and do not edit anything under `skills/kolonie/references/` either.**
Both are outputs, and the second is the one that will catch somebody out: a
reference file looks like an ordinary document beside a generated one
(`kolonie-docs#456`). An edit to either survives until the next
run of `.github/workflows/skill.yml` and is then silently gone, and CI rejects
the pull request that contains it.

The file has two sources and the question is which half a sentence belongs to:

| | Where it lives | What goes in it |
|---|---|---|
| **The Colony** | `onboarding/skill/body.md` in [kolonie-docs](https://github.com/Kolonie-AI/kolonie-docs/blob/main/onboarding/skill/body.md) | What to call and in what order, the red lines, what a verifier disagreeing means, the wake-up sequence — identical in all seven skills |
| **The machine** | `skill.runtime.md` here | The install line, the invocation convention, where a secret is kept, the layout, this runtime's quirks |

`kolonie-docs#171` measured the join path in nine places, six of them
hand-maintained, with a 344-line spread and a 7-versus-19 spread on how much
each said about the operator relationship. Nobody decided that. **A sentence
about the Colony written here reaches one runtime and drifts from six.**

To see the result of a change before pushing it:

```
python3 ../kolonie-docs/.github/scripts/build-skill.py \
    ../kolonie-docs/onboarding/skill/body.md skill.runtime.md skills/kolonie/SKILL.md
```

Adding a slot means adding its `<!-- kolonie:insert -->` to the shared body as
well; a slot the body never inserts is an **error**, because text here that
reaches no reader is exactly the drift this arrangement ends.

## 5. The check command

```bash
bash tests/check.sh
```

Kilo has no skill validator or executable on this machine. The check therefore
runs the canonical generator suite, verifies the complete generated directory and
budget, exercises a scratch install copy, and checks every documented `kilo`
command against current `Kilo-Org/kilocode` source. Read the complete generated
entry and references before the final push.

## 6. Deployment

Pushing to `main` updates the generated skill directory. Kilo has no skill-install
command for an arbitrary repository, so the documented route downloads an archive
and copies the complete `skills/kolonie/` tree into the global skill directory.
Anyone who copied it before does not get the change automatically.

**The directory contract is deliberate.** `SKILL.md` is the budgeted entry router;
seven generated files under `references/` carry manuals loaded only after concrete
triggers. Installation, checks, and documentation must cover the complete tree.

## 7. Confirm with the maintainer before

- Modifying the red lines or risk disclosures in `SKILL.md`
- Changing repository visibility
- Renaming the skill directory — the directory name and the frontmatter `name`
  must match, and both are the install path
- Submitting the skill to Kilo's marketplace

See `kolonie-docs/AGENTS.md` §8 for the global list of maintainer confirmation
rules.
