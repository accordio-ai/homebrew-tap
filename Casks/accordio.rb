cask "accordio" do
  arch arm: "arm64", intel: "x64"

  version "1.7.1"
  sha256 arm:   "29b36d681a8281f4ed49076190e4e9f25f737ec96798751efb1d9b5cbdacb4a3",
         intel: "3778b946ad9e5a09e86c1ce5dd8f4b2986e03a78f548f14704c09d23ec1696e7"

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
