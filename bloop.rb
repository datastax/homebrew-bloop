class Bloop < Formula
  desc "Bloop is a build server to compile, test and run Scala fast"
  homepage "https://github.com/scalacenter/bloop"
  version "1.3.3-dse-1"
  url "https://github.com/jacek-lewandowski/bloop/archive/v1.3.3-dse-1.tar.gz"
  sha256 "4008dd8868de8faf186c26a613bbd34648ab78b4d1737d73855c864043bf614b"
  bottle :unneeded

  depends_on "bash-completion"
  depends_on "python3"
  depends_on :java => "1.8+"
  depends_on "sbt"

  def install
      system "pwd"
      system "ls -l"
      system "tar", "-xf", "bloop-#{version}.tar.gz", "--strip", "1"
      system "git", "submodule", "update", "--init"
      system "sbt", "install"
      system "chmod", "a+x", "./frontend/target/install.py"
      system "./frontend/target/install.py"
      zsh_completion.install "bin/zsh/_bloop"
      bash_completion.install "bin/bash/bloop"
      fish_completion.install "bin/fish/bloop.fish"

      # We need to create these files manually here, because otherwise launchd
      # will create them with owner set to `root` (see the plist file below).
      FileUtils.mkdir_p("log/bloop/")
      FileUtils.touch("log/bloop/bloop.out.log")
      FileUtils.touch("log/bloop/bloop.err.log")

      prefix.install "bin"
      prefix.install "log"
  end

  def plist; <<~EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>#{plist_name}</string>
    <key>ProgramArguments</key>
    <array>
        <string>#{bin}/bloop</string>
        <string>server</string>
    </array>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>#{prefix}/log/bloop/bloop.out.log</string>
    <key>StandardErrorPath</key>
    <string>#{prefix}/log/bloop/bloop.err.log</string>
</dict>
</plist>
          EOS
      end

  test do
  end
end