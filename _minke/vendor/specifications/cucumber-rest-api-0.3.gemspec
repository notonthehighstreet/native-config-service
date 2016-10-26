# -*- encoding: utf-8 -*-
# stub: cucumber-rest-api 0.3 ruby lib

Gem::Specification.new do |s|
  s.name = "cucumber-rest-api".freeze
  s.version = "0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Anupama Vijaykumar,Nic Jackson".freeze]
  s.date = "2014-02-19"
  s.description = "Cucumber steps to easily test REST-based XML and JSON APIs".freeze
  s.email = ["anupama.vijaykumar@marks-and-spencer.com".freeze]
  s.homepage = "https://github.com/DigitalInnovation/cucumber_rest_api".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "2.6.7".freeze
  s.summary = "Cucumber steps to easily test REST-based XML and JSON APIs".freeze

  s.installed_by_version = "2.6.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jsonpath>.freeze, [">= 0.1.2"])
      s.add_runtime_dependency(%q<nokogiri>.freeze, [">= 1.6.0"])
      s.add_runtime_dependency(%q<cucumber>.freeze, [">= 1.2.1"])
      s.add_runtime_dependency(%q<rspec>.freeze, [">= 2.12.0"])
    else
      s.add_dependency(%q<jsonpath>.freeze, [">= 0.1.2"])
      s.add_dependency(%q<nokogiri>.freeze, [">= 1.6.0"])
      s.add_dependency(%q<cucumber>.freeze, [">= 1.2.1"])
      s.add_dependency(%q<rspec>.freeze, [">= 2.12.0"])
    end
  else
    s.add_dependency(%q<jsonpath>.freeze, [">= 0.1.2"])
    s.add_dependency(%q<nokogiri>.freeze, [">= 1.6.0"])
    s.add_dependency(%q<cucumber>.freeze, [">= 1.2.1"])
    s.add_dependency(%q<rspec>.freeze, [">= 2.12.0"])
  end
end
