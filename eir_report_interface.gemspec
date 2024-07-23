# frozen_string_literal: true

require_relative "lib/eir_report_interface/version"

Gem::Specification.new do |spec|
  spec.name = "eir_report_interface"
  spec.version = EIRReportInterface::VERSION
  spec.authors = ["dominickasanga"]
  spec.email = ["dominickasanga@gmail.com"]

  spec.summary = "Write a short summary, because RubyGems requires one."
  spec.description = "Write a longer description or delete this line."
  spec.homepage = "https://github.com/LUKEINTERNATIONAL/eir_report_interface.git"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/LUKEINTERNATIONAL/eir_report_interface.git"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 7.0.6"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rest-client","~> 2.1"
  spec.add_development_dependency "mysql2", "~> 0"
  spec.add_development_dependency "sqlite3", ">= 1.3.6", "~> 1.3"
end
