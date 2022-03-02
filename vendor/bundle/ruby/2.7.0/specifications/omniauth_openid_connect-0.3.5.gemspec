# -*- encoding: utf-8 -*-
# stub: omniauth_openid_connect 0.3.5 ruby lib

Gem::Specification.new do |s|
  s.name = "omniauth_openid_connect".freeze
  s.version = "0.3.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["John Bohn".freeze, "Ilya Shcherbinin".freeze]
  s.date = "2020-06-07"
  s.description = "OpenID Connect Strategy for OmniAuth.".freeze
  s.email = ["jjbohn@gmail.com".freeze, "m0n9oose@gmail.com".freeze]
  s.homepage = "https://github.com/m0n9oose/omniauth_openid_connect".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.4".freeze
  s.summary = "OpenID Connect Strategy for OmniAuth".freeze

  s.installed_by_version = "3.1.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<addressable>.freeze, ["~> 2.5"])
    s.add_runtime_dependency(%q<omniauth>.freeze, ["~> 1.9"])
    s.add_runtime_dependency(%q<openid_connect>.freeze, ["~> 1.1"])
    s.add_development_dependency(%q<coveralls>.freeze, ["~> 0.8"])
    s.add_development_dependency(%q<faker>.freeze, ["~> 1.6"])
    s.add_development_dependency(%q<guard>.freeze, ["~> 2.14"])
    s.add_development_dependency(%q<guard-bundler>.freeze, ["~> 2.2"])
    s.add_development_dependency(%q<guard-minitest>.freeze, ["~> 2.4"])
    s.add_development_dependency(%q<minitest>.freeze, ["~> 5.1"])
    s.add_development_dependency(%q<mocha>.freeze, ["~> 1.7"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 12.0"])
    s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.63"])
    s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.12"])
  else
    s.add_dependency(%q<addressable>.freeze, ["~> 2.5"])
    s.add_dependency(%q<omniauth>.freeze, ["~> 1.9"])
    s.add_dependency(%q<openid_connect>.freeze, ["~> 1.1"])
    s.add_dependency(%q<coveralls>.freeze, ["~> 0.8"])
    s.add_dependency(%q<faker>.freeze, ["~> 1.6"])
    s.add_dependency(%q<guard>.freeze, ["~> 2.14"])
    s.add_dependency(%q<guard-bundler>.freeze, ["~> 2.2"])
    s.add_dependency(%q<guard-minitest>.freeze, ["~> 2.4"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.1"])
    s.add_dependency(%q<mocha>.freeze, ["~> 1.7"])
    s.add_dependency(%q<rake>.freeze, ["~> 12.0"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 0.63"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.12"])
  end
end
