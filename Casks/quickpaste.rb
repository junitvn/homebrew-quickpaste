cask "quickpaste" do
  version "1.2.0"
  # Run ./build_app.sh to get the SHA256 for the new release zip,
  # then update this value before pushing the cask.
  sha256 "8e56496eb32fc6433130708562bcc910cf7156ca408cdc28f94d8b3c22457b24"

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
