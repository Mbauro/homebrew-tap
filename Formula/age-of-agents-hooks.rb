class AgeOfAgentsHooks < Formula
  desc "Connect coding-agent lifecycle hooks to Age of Agents"
  homepage "https://github.com/Mbauro/age-of-agents-hooks"
  url "https://github.com/Mbauro/age-of-agents-hooks/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "426cf6ddb7bec31c329d8969fc461c8ee3c5460523eb5b0f1da090e4eb110949"
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
