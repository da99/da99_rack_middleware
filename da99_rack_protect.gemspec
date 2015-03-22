# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "da99_rack_protect"
  spec.version       = `cat VERSION`
  spec.authors       = ["da99"]
  spec.email         = ["i-hate-spam-1234567@mailinator.com"]
  spec.summary       = %q{My personal list of rack middlewares for web apps.}
  spec.description   = %q{
    Various rack middlewares I use for projects.
    I got tired of copying/pasting the same ones for
    different apps.
  }
  spec.homepage      = "https://github.com/da99/da99_rack_protect"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |file|
    file.index('bin/') == 0 && file != "bin/#{File.basename Dir.pwd}"
  }
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rack-protection"           , "> 1.5"

  spec.add_development_dependency "pry"           , "> 0.9"
  spec.add_development_dependency "bundler"       , "> 1.5"
  spec.add_development_dependency "bacon"         , "> 1.0"
  spec.add_development_dependency "Bacon_Colored" , "> 0.1"
  spec.add_development_dependency "cuba" , "> 3.2"
  spec.add_development_dependency "thin" , "> 1.6"
end
