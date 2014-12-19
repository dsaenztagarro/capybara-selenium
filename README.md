[![Gem Version](https://badge.fury.io/rb/capybara-selenium.svg)](http://badge.fury.io/rb/capybara-selenium)
[![Code Climate](https://codeclimate.com/github/dsaenztagarro/capybara-selenium/badges/gpa.svg)](https://codeclimate.com/github/dsaenztagarro/capybara-selenium)
[![Dependency Status](https://gemnasium.com/dsaenztagarro/capybara-selenium.svg)](https://gemnasium.com/dsaenztagarro/capybara-selenium)

# CapybaraSelenium

Dead-simple way to make Capybara and Selenium play together

## Roadmap

CapybaraSelenium is on its way towards 1.0.0. Please refer to 
[issues](https://github.com/dsaenztagarro/capybara-selenium/issues) for details.

## Installation

Add this line to your application's Gemfile:

    gem 'capybara-selenium'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capybara-selenium

## Usage

Supported application servers:

- Modular sinatra apps (through config.ru)

Supported selenium servers:

- Remote selenium server

```ruby
# features/support/continous_integration.rb
APP_SERVER_HOST = ENV['CI_APP_SERVER_HOST'] || 'localhost'
APP_SERVER_PORT = ENV['CI_APP_SERVER_PORT'] || 8080
SELENIUM_SERVER_URL = ENV['CI_SELENIUM_SERVER_URL'] || 
                      'http://127.0.0.1:4444/wd/hub'

CapybaraSelenium::Configurator.new do |app_server, selenium_server|
  app_server.host = APP_SERVER_HOST
  app_server.port = APP_SERVER_PORT
  app_server.config_ru_path  = File.expand_path(
      File.join(__FILE__, '../web_app/config.ru'))

  selenium_server.server_url = SELENIUM_SERVER_URL
  selenium_server.capabilities = { browser_name: browser_name }
end.configure
```

## Contributing

1. Fork it ( https://github.com/dsaenztagarro/capybara_selenium/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
