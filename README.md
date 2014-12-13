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

```ruby
# features/support/continous_integration.rb
module ContinousIntegration
  def app_server(opts = {})
    {
      host: ENV['CI_APP_SERVER_HOST'] || 'localhost',
      port: ENV['CI_APP_SERVER_PORT'] || 8080,
      type: :rack,
      config_ru_path: ENV['CI_APP_SERVER_CONFIG_RU'] || config_ru_path
    }.merge(opts)
  end

  def selenium_server(opts = {})
    {
      type: :remote,
      url: ENV['CI_SELENIUM_SERVER_URL'] || 'http://127.0.0.1:4444/wd/hub',
      capabilities: {
        browser_name: :firefox
      }
    }.merge(opts)
  end

  def driver_for(browser_name)
    CapybaraSelenium::GlobalConfigurator.new(
      app_server: app_server,
      selenium_server: selenium_server.merge(
        capabilities: {
          browser_name: browser_name
        })
    ).driver
  end

  def config_ru_path
    File.expand_path(File.join(__FILE__, '../dummy_app/config.ru'))
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
