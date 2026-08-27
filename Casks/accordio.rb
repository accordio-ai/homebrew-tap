cask "accordio" do
  arch arm: "arm64", intel: "x64"

  version "1.6.3"
  sha256 arm:   "a5e30b2aff8f3742e090f14ff73ceced6e4ec54dc61dbe90ce3f2364fe3040a2",
         intel: "7ebc6fcb843d1f45639295c585bc7e770484b1c6efb365a548c3f9eaeb9cd58f"

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
