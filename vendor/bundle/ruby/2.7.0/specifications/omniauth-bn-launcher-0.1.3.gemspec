# -*- encoding: utf-8 -*-
# stub: omniauth-bn-launcher 0.1.3 ruby lib

Gem::Specification.new do |s|
  s.name = "omniauth-bn-launcher".freeze
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["bruckwubete".freeze]
  s.bindir = "exe".freeze
  s.date = "2020-04-20"
  s.description = "A ruby gem for auth integration of Blindside Networks customers".freeze
  s.email = ["bruckwendwessenwubet@cmail.carleton.ca".freeze]
  s.homepage = "https://github.com/blindsidenetworks/omniauth-bn-launcher.git".freeze
  s.rubygems_version = "3.1.4".freeze
  s.summary = "Blindside Networks auth launcher".freeze

  s.installed_by_version = "3.1.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<bundler>.freeze, ["~> 1.16"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_development_dependency(%q<rack-test>.freeze, ["~> 0.6", ">= 0.6.3"])
    s.add_development_dependency(%q<omniauth-oauth2>.freeze, ["= 1.5.0"])
    s.add_runtime_dependency(%q<omniauth>.freeze, ["~> 1.3", ">= 1.3.2"])
    s.add_runtime_dependency(%q<omniauth-oauth2>.freeze, ["= 1.5.0"])
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.16"])
    s.add_dependency(%q<rake>.freeze, ["~> 13.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<rack-test>.freeze, ["~> 0.6", ">= 0.6.3"])
    s.add_dependency(%q<omniauth-oauth2>.freeze, ["= 1.5.0"])
    s.add_dependency(%q<omniauth>.freeze, ["~> 1.3", ">= 1.3.2"])
    s.add_dependency(%q<omniauth-oauth2>.freeze, ["= 1.5.0"])
  end
end
