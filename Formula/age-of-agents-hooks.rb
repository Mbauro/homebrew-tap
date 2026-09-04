class AgeOfAgentsHooks < Formula
  desc "Connect coding-agent lifecycle hooks to Age of Agents"
  homepage "https://github.com/Mbauro/age-of-agents-hooks"
  url "https://github.com/Mbauro/age-of-agents-hooks/releases/download/v1.0.0/age-of-agents-hooks-1.0.0.tar.gz"
  sha256 "f5fb57d97b9e9a7109a455ae78256c12023c388de122558e81c7f350059a1be3"
  license "MIT"

  depends_on "node"

  def install
    libexec.install "bin", "lib", "package.json", "LICENSE", "README.md"
    (bin/"age-of-agents-hooks").write <<~SH
      #!/bin/bash
      export PATH="#{formula_opt_bin("node")}:$PATH"
      export AGE_OF_AGENTS_COMMAND="#{opt_bin}/age-of-agents-hooks"
      exec "#{libexec}/bin/age-of-agents-hooks.js" "$@"
    SH
    chmod 0755, bin/"age-of-agents-hooks"
  end

  def caveats
    <<~EOS
      Create a one-time pairing code in Age of Agents, then run:
        age-of-agents-hooks install

      Before uninstalling, remove managed hooks and local credentials with:
        age-of-agents-hooks uninstall --purge
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/age-of-agents-hooks version").strip
    assert_equal "https://example.invalid",
      shell_output("#{bin}/age-of-agents-hooks validate-url https://example.invalid/").strip
  end
end
