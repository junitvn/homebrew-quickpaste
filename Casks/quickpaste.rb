cask "quickpaste" do
  version "1.3.0"
  # Run ./build_app.sh to get the SHA256 for the new release zip,
  # then update this value before pushing the cask.
  sha256 "1cef0637ad501037a97cebc50d3c51ba43c9c72f27db2537b2ce54ed37166fc1"

  url "https://github.com/junitvn/quickpaste/releases/download/v#{version}/QuickPaste-#{version}.zip"
  name "QuickPaste"
  desc "Fast native macOS clipboard manager with snippets and quick actions"
  homepage "https://github.com/junitvn/quickpaste"

  app "QuickPaste.app"

  # Strip the quarantine flag that macOS adds to downloaded files.
  # Without this the app shows "damaged and can't be opened" and
  # Accessibility permission silently fails.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/QuickPaste.app"],
                   sudo: false
  end

  # Reset the TCC Accessibility entry so macOS re-prompts on first launch.
  # (Ad-hoc codesign identity changes between builds, invalidating old grants.)
  postflight do
    system_command "/usr/bin/tccutil",
                   args: ["reset", "Accessibility", "com.lamnguyen.quickpaste"],
                   sudo: false
  end

  uninstall quit: "com.lamnguyen.quickpaste"

  zap trash: [
    "~/Library/Preferences/com.lamnguyen.quickpaste.plist",
  ]
end
