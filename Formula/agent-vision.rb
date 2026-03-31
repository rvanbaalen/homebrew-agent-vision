class AgentVision < Formula
  desc "Give AI agents eyes on your screen"
  homepage "https://github.com/rvanbaalen/agent-vision"
  url "https://github.com/rvanbaalen/agent-vision/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "a25f437484df6725ed0d1a102bdcd8b4d9159a84d7195d57132651c7222a8e0e"
  license "MIT"

  depends_on xcode: ["16.0", :build]
  depends_on :macos => :sonoma
  depends_on arch: :arm64

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"

    app_bundle = prefix/"Agent Vision.app"
    (app_bundle/"Contents/MacOS").mkpath
    (app_bundle/"Contents/Resources").mkpath

    cp ".build/release/agent-vision", app_bundle/"Contents/MacOS/agent-vision"

    (app_bundle/"Contents/Info.plist").write <<~PLIST
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
        "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleName</key>
        <string>Agent Vision</string>
        <key>CFBundleDisplayName</key>
        <string>Agent Vision</string>
        <key>CFBundleIdentifier</key>
        <string>com.agent-vision.app</string>
        <key>CFBundleVersion</key>
        <string>#{version}</string>
        <key>CFBundleShortVersionString</key>
        <string>#{version}</string>
        <key>CFBundleExecutable</key>
        <string>agent-vision</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>LSMinimumSystemVersion</key>
        <string>14.0</string>
        <key>LSUIElement</key>
        <true/>
        <key>NSScreenCaptureUsageDescription</key>
        <string>Agent Vision needs screen recording access to capture screenshots of the selected area.</string>
      </dict>
      </plist>
    PLIST

    system "codesign", "--force", "--sign", "-", "--deep", app_bundle.to_s

    bin.install_symlink app_bundle/"Contents/MacOS/agent-vision"
  end

  def caveats
    <<~EOS
      Agent Vision requires macOS permissions:
        - Screen Recording (System Settings > Privacy & Security > Screen Recording)
        - Accessibility (System Settings > Privacy & Security > Accessibility)
    EOS
  end

  test do
    assert_match "agent-vision", shell_output("#{bin}/agent-vision --help")
  end
end
