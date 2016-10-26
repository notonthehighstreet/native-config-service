# -*- encoding: utf-8 -*-
# stub: minke 1.13.16 ruby lib

Gem::Specification.new do |s|
  s.name = "minke".freeze
  s.version = "1.13.16"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Nic Jackson".freeze]
  s.date = "2016-10-26"
  s.email = ["jackson.nic@gmail.com".freeze]
  s.executables = ["minke".freeze]
  s.files = ["bin/minke".freeze]
  s.homepage = "https://github.com/nicholasjackson/minke".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.6.7".freeze
  s.summary = "Minke is a suite of rake tasks for building and testing microservices with Docker.  Currently supporting Google Go, Node.js services are coming soon.".freeze

  s.installed_by_version = "2.6.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.10"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<guard>.freeze, [">= 0"])
      s.add_development_dependency(%q<guard-rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<webmock>.freeze, [">= 0"])
      s.add_development_dependency(%q<pry>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<sshkey>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<colorize>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<cucumber>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_runtime_dependency(%q<docker-api>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<rest-client>.freeze, ["~> 1.8"])
      s.add_runtime_dependency(%q<consul_loader>.freeze, ["~> 1.0"])
      s.add_runtime_dependency(%q<multi_json>.freeze, [">= 0"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.10"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<guard>.freeze, [">= 0"])
      s.add_dependency(%q<guard-rspec>.freeze, [">= 0"])
      s.add_dependency(%q<webmock>.freeze, [">= 0"])
      s.add_dependency(%q<pry>.freeze, [">= 0"])
      s.add_dependency(%q<sshkey>.freeze, [">= 0"])
      s.add_dependency(%q<colorize>.freeze, [">= 0"])
      s.add_dependency(%q<cucumber>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_dependency(%q<docker-api>.freeze, [">= 0"])
      s.add_dependency(%q<rest-client>.freeze, ["~> 1.8"])
      s.add_dependency(%q<consul_loader>.freeze, ["~> 1.0"])
      s.add_dependency(%q<multi_json>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.10"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<guard>.freeze, [">= 0"])
    s.add_dependency(%q<guard-rspec>.freeze, [">= 0"])
    s.add_dependency(%q<webmock>.freeze, [">= 0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
    s.add_dependency(%q<sshkey>.freeze, [">= 0"])
    s.add_dependency(%q<colorize>.freeze, [">= 0"])
    s.add_dependency(%q<cucumber>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<docker-api>.freeze, [">= 0"])
    s.add_dependency(%q<rest-client>.freeze, ["~> 1.8"])
    s.add_dependency(%q<consul_loader>.freeze, ["~> 1.0"])
    s.add_dependency(%q<multi_json>.freeze, [">= 0"])
  end
end
