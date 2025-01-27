class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator.git",
    :tag      => "v0.5.1",
    :revision => "d7c0b2e9131faabb2b09dd804a35ee03822f8447"
  sha256 "d077ce973e5917fab7cbad46bc2d19264e8d0ae23321afd97b1bc481075a31fa"
  head "https://github.com/kubernetes-sigs/aws-iam-authenticator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e9fac73ba6dbb0fe06c22a2fa83cc11ae315017fa0d8c24e2a881f9c4d605d8" => :catalina
    sha256 "dc6692a1b5829c1c5a2eab36ad73809aa68005bd3c23f7e70137d9ade8481172" => :mojave
    sha256 "bd6f1496f048c69936d0cca717cae2163e0cdcdb8cc57c0b7f2e563a9063bc46" => :high_sierra
    sha256 "8644a176d6b79364c6a2f1c4fe2848073f7c3d1ec69a933a579df48312169d5f" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    # project = "github.com/kubernetes-sigs/aws-iam-authenticator"
    revision = Utils.safe_popen_read("git", "rev-parse", "HEAD").strip
    version = Utils.safe_popen_read("git describe --tags").strip
    ldflags = ["-s", "-w",
               "-X main.version=#{version}",
               "-X main.commit=#{revision}"]
    system "go", "build", "-ldflags", ldflags.join(" "), "-trimpath",
           "-o", bin/"aws-iam-authenticator", "./cmd/aws-iam-authenticator"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/aws-iam-authenticator version")
    assert_match "\"Version\":\"v#{version}\"", output

    system "#{bin}/aws-iam-authenticator", "init", "-i", "test"
    contents = Dir.entries(".")
    ["cert.pem", "key.pem", "aws-iam-authenticator.kubeconfig"].each do |created|
      assert_include contents, created
    end
  end
end
