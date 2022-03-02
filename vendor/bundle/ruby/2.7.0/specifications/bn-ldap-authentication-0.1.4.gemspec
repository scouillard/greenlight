# -*- encoding: utf-8 -*-
# stub: bn-ldap-authentication 0.1.4 ruby lib

Gem::Specification.new do |s|
  s.name = "bn-ldap-authentication".freeze
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["shawn-higgins1".freeze]
  s.bindir = "exe".freeze
  s.date = "2020-06-10"
  s.description = "A ruby gem for using ldap to authenticate greenlight users".freeze
  s.email = ["23224097+shawn-higgins1@users.noreply.github.com".freeze]
  s.homepage = "https://github.com/blindsidenetworks/bn-ldap-authentication".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.1.4".freeze
  s.summary = "An ruby gem for authenticating users with ldap".freeze

  s.installed_by_version = "3.1.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<bundler>.freeze, ["~> 1.11"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_runtime_dependency(%q<net-ldap>.freeze, ["~> 0"])
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.11"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<net-ldap>.freeze, ["~> 0"])
  end
end
