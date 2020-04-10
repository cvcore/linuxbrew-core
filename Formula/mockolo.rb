class Mockolo < Formula
  desc "Efficient Mock Generator for Swift"
  homepage "https://github.com/uber/mockolo"
  url "https://github.com/uber/mockolo/archive/1.2.0.tar.gz"
  sha256 "e687bee4b1e9979e7e0d94a798d4a430137e07894f5fcbe418a243a3751c1edf"

  bottle do
    cellar :any_skip_relocation
    sha256 "71779539ff2853e2e41fa076a7da71ad898b3f3b18afa6ba00d133820342ab98" => :catalina
    sha256 "50430c0872393a8811c96deb06c20a25b94f47c244b7f98a64af91f738780c7d" => :mojave
  end

  depends_on :xcode => ["11.0", :build]

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/mockolo"
  end

  test do
    (testpath/"testfile.swift").write("
    /// @mockable
    public protocol Foo {
        var num: Int { get set }
        func bar(arg: Float) -> String
    }")
    system "#{bin}/mockolo", "-srcs", testpath/"testfile.swift", "-d", testpath/"GeneratedMocks.swift"
    assert_predicate testpath/"GeneratedMocks.swift", :exist?
    assert_equal "
    ///
    /// @Generated by Mockolo
    ///
    public class FooMock: Foo {
      public init() { }
      public init(num: Int = 0) {
          self.num = num
      }

      public var numSetCallCount = 0
      public var num: Int = 0 { didSet { numSetCallCount += 1 } }

      public var barCallCount = 0
      public var barHandler: ((Float) -> (String))?
      public func bar(arg: Float) -> String {
          barCallCount += 1
          if let barHandler = barHandler {
              return barHandler(arg)
          }
          return \"\"
      }
    }".gsub(/\s+/, "").strip, shell_output("cat #{testpath/"GeneratedMocks.swift"}").gsub(/\s+/, "").strip
  end
end
