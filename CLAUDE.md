# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Docker-based GitHub Action that validates hyperlinks in markdown files using the [markdown-link-check](https://github.com/tcort/markdown-link-check) npm package. Fork of the unmaintained `gaurav-nelson/github-action-markdown-link-check`.

## Architecture

Three files compose the entire action:

- **action.yml** — Defines 9 input parameters and maps them as positional args (`$1`–`$9`) to the entrypoint
- **Dockerfile** — Alpine-based Node.js image; installs bash and git; runs `entrypoint.sh`
- **entrypoint.sh** — Core bash script that installs `markdown-link-check@3.14.2` globally, finds markdown files via `find`, runs the checker, captures output to `error.txt`, and greps for `"ERROR:"` to determine pass/fail (exit 113 on failure)

**Two execution modes** in `entrypoint.sh`:
1. **Full check** (default) — Uses `find` to locate all files matching the extension pattern
2. **Modified files only** (`check-modified-files-only: yes`) — Uses `git diff` against the base branch to check only changed files

The `md/` directory contains test markdown files used by the CI workflow.

## Testing & Linting

There is no local test harness. Testing is done via the GitHub Actions workflow on PRs:

```bash
# Lint the bash script
shellcheck entrypoint.sh
```

The CI workflow (`.github/workflows/push.yml`) runs two test scenarios on PRs: modified-files-only mode, and specific-folders-with-additional-files mode. It also runs ShellCheck on the entrypoint script.

## Key Details

- The script uses `set -eu` — unset variables and command failures are fatal
- Output is captured to `error.txt` via `&>>`, then `check_errors()` greps for the literal string `"ERROR:"` to decide pass/fail
- `mlc_config.json` is the default config file; users override via the `config-file` input
- Exit codes: 0 = success, 2 = missing directory/file, 113 = broken links found
- GitHub outputs: `MLC_OUTPUT` env var (on error) and output variable (on success)