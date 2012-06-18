# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "cucumber-sinatra"
  s.version = "0.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bernd Ahlers"]
  s.date = "2012-04-01"
  s.description = "This little gem will help you to initialize a cucumber environment for a sinatra application. It will generate the required files from templates."
  s.email = "bernd@tuneafish.de"
  s.executables = ["cucumber-sinatra"]
  s.extra_rdoc_files = ["README.md", "LICENSE"]
  s.files = ["bin/cucumber-sinatra", "README.md", "LICENSE"]
  s.homepage = "http://github.com/bernd/cucumber-sinatra"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "cucumber-sinatra"
  s.rubygems_version = "1.8.23"
  s.summary = "Initialize a cucumber environment for sinatra"

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<templater>, [">= 1.0.0"])
    else
      s.add_dependency(%q<templater>, [">= 1.0.0"])
    end
  else
    s.add_dependency(%q<templater>, [">= 1.0.0"])
  end
end
