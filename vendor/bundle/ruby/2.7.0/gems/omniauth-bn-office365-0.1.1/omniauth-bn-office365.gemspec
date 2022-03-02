lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require File.expand_path('../lib/omniauth/omniauth-bn-office365/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "omniauth-bn-office365"
  gem.version       = OmniAuth::BN::OFFICE365::VERSION
  gem.authors       = ["shawn-higgins1"]
  gem.email         = ["23224097+shawn-higgins1@users.noreply.github.com"]

  gem.summary       = "An omniauth provider for Azure Active Directory"
  gem.description   = "A ruby gem for using omniauth to authenticate Azure Active Directory users"
  gem.homepage      = "https://github.com/blindsidenetworks/omniauth-bn-office365"
  gem.license       = "MIT"


  gem.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  gem.bindir        = "exe"
  gem.executables   = gem.files.grep(%r{^exe/}) { |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_development_dependency "bundler", "~> 1.11"
  gem.add_development_dependency "rake", "~> 10.0"
  gem.add_development_dependency "rspec", "~> 3.0"

  gem.add_runtime_dependency 'omniauth', '>= 1.3.2'
  gem.add_runtime_dependency 'omniauth-oauth2', '>= 1.5.0'
end
