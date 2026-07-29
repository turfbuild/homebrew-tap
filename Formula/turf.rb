class Turf < Formula
  desc "Drop-in replacement for Terraform with agentic superpowers (alpha)"
  homepage "https://github.com/turfbuild/turf"
  # Pinned explicitly: Homebrew's URL version scanner mis-reads a plain vX.Y.Z
  # tag (grabs "64" from amd64/arm64), so set it here rather than rely on the URL.
  version "0.10.0"
  # PolyForm Free Trial 1.0.0 is not an SPDX/OSI identifier; :cannot_represent
  # is correct for a custom tap (this is not submitted to homebrew-core).
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.10.0/turf_v0.10.0_darwin_arm64.tar.gz"
      sha256 "37fd2337dfd29ed8e0d9619835e03f54c8ba9bb814d8a72f2a5bf97fbf6eb1e8"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.10.0/turf_v0.10.0_darwin_amd64.tar.gz"
      sha256 "b4bbb9e2d392347bce74ff975d8c76cfb1071b38ef7d595feffb059f51c6cc9a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/turfbuild/turf/releases/download/v0.10.0/turf_v0.10.0_linux_arm64.tar.gz"
      sha256 "20d63cf35e378f5bd327922143376a90d7918c540233868b327e228848797649"
    end
    on_intel do
      url "https://github.com/turfbuild/turf/releases/download/v0.10.0/turf_v0.10.0_linux_amd64.tar.gz"
      sha256 "0d1b347cae190a30fddc1fe2b60df7d41911774ed581f96fd2c35f8b8422e38f"
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
