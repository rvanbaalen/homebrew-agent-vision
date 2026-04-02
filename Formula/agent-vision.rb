class AgentVision < Formula
  desc "Give AI agents eyes on your screen"
  homepage "https://github.com/rvanbaalen/agent-vision"
  url "https://github.com/rvanbaalen/agent-vision/releases/download/v0.6.4/agent-vision-arm64.tar.gz"
  sha256 "FILL_AFTER_RELEASE"
  license "MIT"

  depends_on :macos => :sonoma
  depends_on arch: :arm64

  def install
    app_bundle = prefix/"Agent Vision.app"
    (app_bundle).mkpath
    cp_r Dir["Agent Vision.app/*"], app_bundle

    # Remove quarantine attribute to prevent Gatekeeper from blocking the ad-hoc signed binary
    system "xattr", "-cr", app_bundle.to_s

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
