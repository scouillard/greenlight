# ominauth-bn-office365

This gem allows you to use Azure Active Directory Authentication with OmniAuth for signing in users.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ominauth-bn-office365'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install omniauth-bn-office365

## Usage


Add the office365 provider to the OmniAuth.rb initializer to use the provider.

    provider :office365, ENV['AZURE_APP_ID'], ENV['AZURE_APP_SECRET'],
        allowed_domains: 'gmail.com'