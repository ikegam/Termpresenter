Gem::Specification.new do |spec|
  spec.name          = "termpresenter"
  spec.version       = "0.1.0"
  spec.summary       = "Terminal presentation tool"
  spec.description   = "TermPresenter converts slides to ASCII art for terminal presentations."
  spec.authors       = ["ikegam"]
  spec.email         = ["example@example.com"]
  spec.files         = Dir["lib/**/*", "bin/*", "presen/**/*", "README*"]
  spec.executables   = ["tmptr"]
  spec.bindir        = "bin"
  spec.required_ruby_version = ">= 2.5"
  spec.add_runtime_dependency "pango"
  spec.add_runtime_dependency "mime-types"
end

