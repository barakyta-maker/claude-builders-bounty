# CHANGELOG Generator

Generate a structured `CHANGELOG.md` from Git history. Commits after the latest Git tag are grouped into **Added**, **Fixed**, **Changed**, and **Removed**. If a repository has no tags yet, the script safely uses the complete history.

## Setup and usage
1. Copy `scripts/changelog.sh` into your Git repository.
2. Run `chmod +x scripts/changelog.sh` once (macOS/Linux/Git Bash).
3. Run `bash scripts/changelog.sh`; the generated file is `CHANGELOG.md`.

## Categorization
- `feat:` / `feature:` ? **Added**
- `fix:` / `bugfix:` ? **Fixed**
- `remove:` / `removed:` / `delete:` / `deleted:` ? **Removed**
- all other commit subjects ? **Changed**

The script ignores merge commits and preserves commit subjects verbatim. `CHANGELOG.md` is replaced on each run so the output is deterministic for the same Git history.

## Real-repository test
Tested against the public GitHub repository `pallets/itsdangerous`. `CHANGELOG.sample.md` contains the resulting output from commits after that repository's latest reachable tag at test time.
