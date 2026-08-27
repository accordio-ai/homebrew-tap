cask "accordio" do
  arch arm: "arm64", intel: "x64"

  version "1.6.4"
  sha256 arm:   "cede57d5caac37ab88aad2b9c696e91a85321203a3ab8f8bd6dc39f081eb43f5",
         intel: "d4c6b6c2dcbcd86f1474cab70c2ad246ed3c2beb718200bedc127c329ef1a702"

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
