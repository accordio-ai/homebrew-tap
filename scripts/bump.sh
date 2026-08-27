#!/usr/bin/env bash
#
# Bump Casks/accordio.rb to a new release.
#
# Reads the sha256 digests from the GitHub release API instead of downloading
# 280 MB of disk images. GitHub computes those digests itself on upload, so they
# are the same bytes Homebrew will verify — `brew fetch` at the end proves it.
#
# Usage: ./scripts/bump.sh 1.7.0

set -euo pipefail

REPO="deduxer-agency/accordio-agi-release"
VERSION="${1:-}"

if [[ -z "$VERSION" ]]; then
  echo "usage: $0 <version>   e.g. $0 1.7.0" >&2
  exit 64
fi

command -v gh >/dev/null || { echo "gh CLI is required" >&2; exit 69; }

CASK="$(cd "$(dirname "$0")/.." && pwd)/Casks/accordio.rb"
[[ -f "$CASK" ]] || { echo "cask not found at $CASK" >&2; exit 66; }

echo "Reading release v$VERSION from $REPO..."
ASSETS="$(gh release view "v$VERSION" --repo "$REPO" --json assets,isDraft)"

if [[ "$(jq -r '.isDraft' <<<"$ASSETS")" == "true" ]]; then
  echo "Release v$VERSION is still a draft. Homebrew gets a 404 on draft assets." >&2
  echo "Run: gh release edit v$VERSION --repo $REPO --draft=false --latest" >&2
  exit 65
fi

digest_for() {
  local name="$1"
  jq -r --arg n "$name" '.assets[] | select(.name == $n) | .digest' <<<"$ASSETS" | sed 's/^sha256://'
}

ARM_SHA="$(digest_for "Accordio-AI-$VERSION-arm64.dmg")"
INTEL_SHA="$(digest_for "Accordio-AI-$VERSION-x64.dmg")"

for pair in "arm64:$ARM_SHA" "x64:$INTEL_SHA"; do
  arch="${pair%%:*}"; sha="${pair#*:}"
  if [[ ! "$sha" =~ ^[0-9a-f]{64}$ ]]; then
    echo "No usable sha256 for the $arch disk image." >&2
    echo "Both Accordio-AI-$VERSION-arm64.dmg and -x64.dmg must be attached to the release." >&2
    exit 65
  fi
done

# Rewrite in place. The sha256 stanza spans two lines, so match it as a block.
/usr/bin/sed -i '' \
  -e "s/^  version \".*\"$/  version \"$VERSION\"/" \
  -e "s|^  sha256 arm:   \".*\",$|  sha256 arm:   \"$ARM_SHA\",|" \
  -e "s|^         intel: \".*\"$|         intel: \"$INTEL_SHA\"|" \
  "$CASK"

echo "Updated $CASK:"
grep -E '^\s+(version|sha256|\s+intel)' "$CASK"

echo
echo "Now verify against the real files:"
echo "  brew style --cask accordio-ai/tap/accordio"
echo "  brew fetch --cask accordio-ai/tap/accordio"
