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

Supported applications:

- [X] Modular sinatra apps (through config.ru)
- [ ] Rails apps

#### Option 1: Using a block in constructor call (Recommended)

```ruby
# features/support/continous_integration.rb
CapybaraSelenium::Configurator.new do
  rack_app_server.configure do |config|
    config.host = ENV['CI_APP_SERVER_HOST'] || 'localhost'
    config.port = ENV['CI_APP_SERVER_PORT'] || 8080
    config.config_ru_path  = File.expand_path(
      File.join(__FILE__, '../web_app/config.ru'))
  end

  remote_selenium_server.configure do |config|
    config.server_url = ENV['CI_SELENIUM_SERVER_URL'] ||
      'http://127.0.0.1:4444/wd/hub'
    config.capabilities = { browser_name: browser_name }
  end
end.dispatch
```

#### Option 2: Using instance methods

```ruby
# features/support/continous_integration.rb
module ContinousIntegration
  def driver_for(browser_name)
    @configurator = CapybaraSelenium::Configurator.new
    configure_rack_app_server
    configure_selenium_server(browser_name)
    @configurator.apply
  end

  def configure_rack_app_server
    @configurator.rack_app_server.configure do |config|
      config.host = ENV['CI_APP_SERVER_HOST'] || 'localhost'
      config.port = ENV['CI_APP_SERVER_PORT'] || 8080
      config.config_ru_path  = File.expand_path(
        File.join(__FILE__, '../web_app/config.ru'))
    end
  end

  def configure_selenium_server(browser_name)
    @configurator.remote_selenium_server.configure do |config|
      config.server_url = ENV['CI_SELENIUM_SERVER_URL'] ||
        'http://127.0.0.1:4444/wd/hub'
      config.capabilities = { browser_name: browser_name }
    end
  end
end

World(ContinousIntegration)
```

## Contributing

1. Fork it ( https://github.com/dsaenztagarro/capybara_selenium/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
