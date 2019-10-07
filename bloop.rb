class Bloop < Formula
  desc "Bloop is a build server to compile, test and run Scala fast"
  homepage "https://github.com/scalacenter/bloop"
  version "1.3.3-dse-1"
  url "https://github.com/pkolaczk/bloop/releases/download/v#{version}/bloop-#{version}.deb"
  sha256 "28e03a6d76eec6e47a232086aa8d59ed7582778ea7d483d045a1b8d6fe5a3277"
  bottle :unneeded

  depends_on "bash-completion"
  depends_on "python3"
  depends_on :java => "1.8+"

  def install
      system "ar", "-x", "bloop-#{version}.deb"
      system "tar", "-xf", "data.tar.xz"
      system "tar", "-xf", "control.tar.xz"
      rm "bloop-#{version}.deb"
      rm "data.tar.xz"
      rm "control.tar.xz"

      zsh_completion.install "opt/bloop/zsh/_bloop"
      bash_completion.install "opt/bloop/bash/bloop"
      fish_completion.install "opt/bloop/fish/bloop.fish"

      bin.install "opt/bloop/bloop"
      bin.install "opt/bloop/blp-coursier"
      bin.install "opt/bloop/blp-server"
      
      # We need to create these files manually here, because otherwise launchd
      # will create them with owner set to `root` (see the plist file below).
      FileUtils.mkdir_p("log/bloop/")
      FileUtils.touch("log/bloop/bloop.out.log")
      FileUtils.touch("log/bloop/bloop.err.log")

      prefix.install "opt"
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