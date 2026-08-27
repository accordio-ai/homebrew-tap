# Accordio Homebrew tap

The Mac tracker, installable from the terminal. One line, no browser, no drag-to-Applications.

```sh
brew install --cask accordio-ai/tap/accordio
```

Homebrew expands `accordio-ai/tap` to the `accordio-ai/homebrew-tap` repository, so there is no separate `brew tap` step.

(The `accordio` GitHub name belongs to an unrelated account, which is why the tap lives under `accordio-ai`. See FLIP-PUBLIC.md step 0.)

## What gets installed

`Accordio AI.app` is a macOS menu bar app that watches which app and window you are working in, attributes that time to a client or project, and hands the result to Accordio so it can become an invoice. It is the capture end of [accordio.ai](https://accordio.ai/); the tracker source lives at [deduxer-agency/accordio-agi](https://github.com/deduxer-agency/accordio-agi).

On first launch macOS asks for Accessibility permission. The app needs it to read the frontmost window title, which is how attribution works. Without it the tracker runs but records nothing.

## Updating

The app updates itself, so the cask is marked `auto_updates true` and `brew upgrade` will not fight it. To move the pinned version anyway:

```sh
brew upgrade --cask accordio
```

## Uninstalling

```sh
brew uninstall --cask accordio          # remove the app
brew uninstall --zap --cask accordio    # also remove settings, caches, and local history
```

`--zap` does not touch the Keychain. Delete the `accordio-agi Safe Storage` entry in Keychain Access if you want the stored sign-in token gone too.

## Supported

macOS 12 (Monterey) and later, Apple Silicon and Intel. The cask picks the matching build automatically.

## Maintaining this tap

`scripts/bump.sh <version>` rewrites `Casks/accordio.rb` for a new release. It reads the sha256 digests straight from the GitHub release API rather than re-downloading the disk images, then verifies the file parses.

```sh
./scripts/bump.sh 1.7.0
brew style --cask accordio-ai/tap/accordio
brew fetch --cask accordio-ai/tap/accordio   # proves the URLs and checksums are real
git commit -am "accordio 1.7.0" && git push
```

Bump only after the GitHub release is published and un-drafted. Draft releases return 404 to Homebrew.
