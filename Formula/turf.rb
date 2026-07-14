class Turf < Formula
  desc "Drop-in replacement for Terraform with agentic superpowers (alpha)"
  homepage "https://github.com/turfbuild/turf"
  # Pinned explicitly: Homebrew's URL version scanner mis-reads a plain vX.Y.Z
  # tag (grabs "64" from amd64/arm64), so set it here rather than rely on the URL.
  version "0.7.0"
  # PolyForm Free Trial 1.0.0 is not an SPDX/OSI identifier; :cannot_represent
  # is correct for a custom tap (this is not submitted to homebrew-core).
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.7.0/turf_v0.7.0_darwin_arm64.tar.gz"
      sha256 "2db98c4db10812692117be108fb5659b1c25382d3555c2a4214fcd1839d30159"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.7.0/turf_v0.7.0_darwin_amd64.tar.gz"
      sha256 "55f8d80f88e331a8942f2e53d9a4f96e25724cb90aee1b9f8a55787cb405fb89"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.7.0/turf_v0.7.0_linux_arm64.tar.gz"
      sha256 "ca71e79e379891d034ec5acb2a80afc315cd7ef872c3dafbc52e205bd957d307"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.7.0/turf_v0.7.0_linux_amd64.tar.gz"
      sha256 "4adf4119178d261e81406ae402d7956d03e9e348d48a4cd9ffb7c2eb93ad0b01"
    end
  end

  def install
    # Install both binaries: the CLI shells out to turf-mcp-server via PATH.
    bin.install "turf", "turf-mcp-server"
    # Keep the evaluation license and third-party notices with the install.
    prefix.install "LICENSE", "NOTICE"
    doc.install "README.md"
  end

  def caveats
    <<~EOS
      Turf is alpha / pre-release evaluation software, provided under the PolyForm
      Free Trial License 1.0.0 (no warranty; see #{opt_prefix}/LICENSE). The `turf`
      CLI is open source (MPL-2.0); component notices are in #{opt_prefix}/NOTICE.
      By installing and using Turf you accept those terms. Please don't redistribute
      the binaries.

      The released CLI is built without CGO on all platforms, so voice/audio input is
      inactive; text chat and all MCP tooling work fully.

      Every release artifact is signed and logged in the public Sigstore transparency
      log. To verify:
        gh attestation verify #{bin}/turf --repo turfbuild/turf
      The server-binary and container-image recipes are in each release's notes:
      https://github.com/turfbuild/turf/releases/latest
    EOS
  end

  test do
    # version.to_s (scanned from the URL) keeps this correct across releases.
    assert_match version.to_s, shell_output("#{bin}/turf --version")
    assert_match version.to_s, shell_output("#{bin}/turf-mcp-server --version")
  end
end
