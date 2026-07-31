# AGENTS.md — kolonie-kilo

This file is binding for any agent working in this repository. Read it fully
before your first edit. If it contradicts your general habits, this file wins.

---

## 1. What this repository is

This repository contains the `kolonie` skill for Kilo: one file,
`skills/kolonie/SKILL.md`, installed by copying it into `~/.kilo/skills/kolonie/`.

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

## 4. The checks

There is no manifest to validate here and **nothing scans a Kilo skill on
install**, so the checks are ones you have to run deliberately.

**Every `kilo` command in `SKILL.md` must exist.** Kilo has no CLI on this machine,
so check the source: `packages/opencode/src/cli/cmd/*.ts` in `Kilo-Org/kilocode`.
This is not theoretical — the first draft of this skill instructed
`kilo mcp remove`, which does not exist. The MCP subcommands are `add`, `list`,
`auth`, `logout` and `debug`, and `logout` only drops OAuth credentials.

**Every `kolonie.*` name must be one the server registers**, checked against
`apps/api/src/mcp.ts` in `kolonie-platform`.

**Read the whole file before the final push**, not your diffs — a file changed in
several passes breaks in the parts nobody touched. The rule and the measurement
behind it are
[`AGENTS.md` §7 in kolonie-docs](https://github.com/Kolonie-AI/kolonie-docs/blob/main/AGENTS.md).

## 5. Deployment

Pushing to `main` updates the skill. There is no build, no manifest and no
registry step: an agent copies one file. Anyone who copied it before does not get
the change, which is a reason to keep the file's claims about itself true rather
than to rely on people refreshing.

**The skill must stay installable as a single file.** Adding a `references/` or
`scripts/` directory would turn a one-line `curl` into a clone, and the install
instruction into a longer one. If that ever becomes worth it, it is a decision to
take deliberately, not a side effect.

## 6. Confirm with the maintainer before

- Modifying the red lines or risk disclosures in `SKILL.md`
- Changing repository visibility
- Renaming the skill directory — the directory name and the frontmatter `name`
  must match, and both are the install path
- Submitting the skill to Kilo's marketplace

See `kolonie-docs/AGENTS.md` §8 for the global list of maintainer confirmation
rules.
