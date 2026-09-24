cask "accordio" do
  arch arm: "arm64", intel: "x64"

  version "1.7.0"
  sha256 arm:   "fa58c9de5cc5accbcdf286525bd66a233940c855fd9db1498635fd625938f9a3",
         intel: "d29a1ded5b06336cf356f0c5c65c1cf80367f5f03ef75df546ddfa7131fc7cd3"

  url "https://github.com/deduxer-agency/accordio-agi-release/releases/download/v#{version}/Accordio-AI-#{version}-#{arch}.dmg",
      verified: "github.com/deduxer-agency/accordio-agi-release/"
  name "Accordio"
  desc "Menu bar time tracker that attributes your work and turns it into invoices"
  homepage "https://accordio.ai/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :monterey

  app "Accordio AI.app"

  uninstall quit: "com.accordio.agi"

  zap trash: [
    "~/Library/Application Support/accordio-agi",
    "~/Library/Caches/accordio-agi-updater",
    "~/Library/HTTPStorages/com.accordio.agi",
    "~/Library/Logs/accordio-agi",
    "~/Library/Preferences/com.accordio.agi.plist",
    "~/Library/Saved Application State/com.accordio.agi.savedState",
  ]

  caveats do
    <<~EOS
      Accordio tracks your work by reading the frontmost window title, so macOS
      will ask for Accessibility permission on first launch:
      System Settings -> Privacy & Security -> Accessibility.

      Your sign-in token is stored in the macOS Keychain. `brew uninstall --zap`
      does not remove Keychain items; delete the "accordio-agi Safe Storage"
      entry in Keychain Access if you want it gone.
    EOS
  end
end
