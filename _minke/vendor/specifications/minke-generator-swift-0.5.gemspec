# -*- encoding: utf-8 -*-
# stub: minke-generator-swift 0.5 ruby lib

Gem::Specification.new do |s|
  s.name = "minke-generator-swift".freeze
  s.version = "0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "entrypoint" => "generators/swift" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Nic Jackson".freeze]
  s.bindir = "exe".freeze
  s.date = "2016-12-05"
  s.description = "Swift Kitura framework with MySQL generator for Minke".freeze
  s.email = ["jackson.nic@gmail.com".freeze]
  s.homepage = "https://github.com/nicholasjackson/minkie-generator-swift".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.6.7".freeze
  s.summary = "Swift Kitura framework generator for Minke".freeze

  s.installed_by_version = "2.6.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.11"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.11"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.11"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
  end
end
