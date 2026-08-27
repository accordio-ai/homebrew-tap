# Flip the tap public

Everything in this directory is finished and validated locally. Nothing has been pushed anywhere. These are the steps only you can run.

Time: about 10 minutes, plus however long you spend on step 0.

---

## Step 0: decide the namespace (blocking, do this first)

> **DECIDED 2026-08-27: `accordio-ai`** (founder's call; underscores are not valid in GitHub names, so `accordio_ai` maps to this). Free and unregistered as of this date — register it before anything else in this file. All references in this directory, the plan doc, overlord's empty-state copy, the site's BREW_COMMAND, and the tracker README have been updated to `accordio-ai`. The table and recommendation below are kept as the decision record.

**The plan's install line cannot be built.** `github.com/accordio` is already taken. It is a personal account belonging to someone called Paweł, registered 2014-03-05, one public repo. Homebrew derives the tap owner from the GitHub account name, so `brew install --cask accordio/tap/accordio` would require that account. It is not available and not worth chasing before Tuesday.

Checked on 2026-08-27, all of these are free:

| GitHub account | Resulting install line |
|---|---|
| `accordio-ai` | `brew install --cask accordio-ai/tap/accordio` |
| `accordiohq` | `brew install --cask accordiohq/tap/accordio` |
| `accordioapp` | `brew install --cask accordioapp/tap/accordio` |
| `getaccordio` | `brew install --cask getaccordio/tap/accordio` |
| `useaccordio` | `brew install --cask useaccordio/tap/accordio` |

You could also skip the new account and publish under the org you already have, which makes the line `brew install --cask deduxer-agency/tap/accordio`. That works today but puts the agency name in a command you are about to paste into a launch thread.

Recommendation: `accordiohq`. `-ai` in a namespace ages badly and `accordio-ai` collides visually with the `accordio-agi` repo name.

Whatever you pick, the cask token stays `accordio`, so the last path segment never changes.

**The files in this directory already assume `accordiohq`.** If you pick anything else, update `README.md` and `scripts/bump.sh` here plus `accordio-agi/README.OSS-DRAFT.md`.

**Either way, the install line still has to be corrected outside this directory.** It is written as the unbuildable `accordio/tap/accordio` in:
- `docs/CLAUDE-AS-A-SERVICE-PLAN.md` (§3 empty-state script, §4 Agent E and F, §5 integration gate)
- the MCP empty-state tool copy in `overlord/` (Agent B owns this)
- the `/claude` page Claude Code tab (Agent F owns this)

A wrong install line in the launch thread is a dead command in front of the exact audience that will try it.

### The other option: skip the tap

`brew install --cask accordio` with no namespace at all means getting into `homebrew/homebrew-cask` itself. That has a notability bar (roughly: a real user base, not a repo published this morning) which Accordio will not clear on launch day. Worth revisiting once the open-source tracker repo has traction. It is a strictly better install line and costs nothing to try later.

---

## Step 1: create the repository

The repo name must literally start with `homebrew-`. Homebrew strips that prefix, which is why `homebrew-tap` becomes `/tap/` in the install line.

```sh
# from the account you chose in step 0
gh repo create <account>/homebrew-tap \
  --public \
  --description "Homebrew tap for Accordio, the Mac time tracker that bills"
```

If `<account>` is a brand-new user account rather than an org, create it on github.com first and `gh auth login` as it, or add it as an org under your existing login.

## Step 2: push these contents

```sh
cd "/Users/romabors/Vibe Coding/Accordio PRODUCT/homebrew-tap-staging"

git init
git add Casks/accordio.rb README.md scripts/bump.sh
git commit -m "accordio 1.6.3"
git branch -M main
git remote add origin git@github.com:<account>/homebrew-tap.git
git push -u origin main
```

Do not commit `FLIP-PUBLIC.md`. It is a note to you, not tap content. The `git add` above lists files explicitly for that reason.

## Step 3: clear the local test tap

While validating, a scratch tap was written to `/opt/homebrew/Library/Taps/accordio/homebrew-tap`. It has been removed, but check anyway. A leftover local tap makes `brew tap` claim the tap already exists and shadows the real one.

```sh
ls "$(brew --repository)/Library/Taps"                  # expect no accordio* entry
rm -rf "$(brew --repository)/Library/Taps/accordio"     # only if one is there
```

## Step 4: test the install for real

Ideally on a Mac that has never had the app, or at least after quitting the running copy.

```sh
brew install --cask <account>/tap/accordio
```

Then confirm, in order:

1. `brew list --cask` lists `accordio`
2. `/Applications/Accordio AI.app` exists and opens to a menu bar icon
3. macOS prompts for Accessibility on first launch, and after granting it the tracker records the frontmost app
4. `brew uninstall --cask accordio` removes the app cleanly
5. `brew uninstall --zap --cask accordio` on a re-install also clears `~/Library/Application Support/accordio-agi`

Step 3 is the one that actually matters. A cask that installs an app which then silently records nothing is worse than no cask.

## Step 5: verify the Claude Code moment

The launch beat is Claude Code installing the tracker itself. Test it the way a stranger will:

```
Set up Accordio for me:
1. run: claude mcp add --transport http accordio https://<mcp-host>/mcp
2. run: brew install --cask <account>/tap/accordio
3. tell me when it is done
```

Watch for the permission prompt. `brew install --cask` needs `sudo` on some machines to write to `/Applications`, which stalls an agent mid-run. If that happens on a clean machine, say so in the thread rather than letting people discover it live.

---

## On every future release

The app auto-updates, so the cask is a convenience, not the update path. Still bump it or new installs get an old version that immediately self-updates.

```sh
gh release edit vX.Y.Z --repo deduxer-agency/accordio-agi-release --draft=false --latest
./scripts/bump.sh X.Y.Z
brew style --cask <account>/tap/accordio
brew fetch --cask <account>/tap/accordio
git commit -am "accordio X.Y.Z" && git push
```

`brew fetch` is the real check. It downloads both disk images and verifies the checksums the cask claims.

---

## What was already validated here

- `brew style --cask`: clean, no offenses
- `brew fetch --cask`: both architectures downloaded and sha256-verified against the live GitHub release assets
- `brew info --cask`: parses, resolves `macOS >= 12`, artifact, caveats
- sha256 values computed from the real 1.6.3 disk images downloaded from the release, and independently cross-checked against GitHub's own upload digests
- `scripts/bump.sh`: round-tripped against 1.6.3, idempotent

`brew audit --cask --online` could **not** run on this machine: brew aborts with "Your Command Line Tools are too outdated" before reaching the cask. That is an environment problem, unrelated to the cask. Run it once your CLT are updated:

```sh
brew audit --cask --online <account>/tap/accordio
```

Expect it to be quiet. `--online` mainly re-checks the URLs and the `verified:` stanza, both of which `brew fetch` already exercised.
