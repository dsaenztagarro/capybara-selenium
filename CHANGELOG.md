## 0.0.6

* Syntax improvements for `CapybaraSelenium::SeleniumServer::RemoteConfigurator`
* Refactoring `configure` method call
* Documentation updated

## 0.0.5

* Fixed capabilities for selenium remote server

## 0.0.4

* Complete refactoring for `CapybaraSelenium::Configurator`
* Documentation updated

## 0.0.3

* Fixed constant name `CapybaraSelenium::Configurator` instead of 
  `CapybaraSelenium::GlobalConfigurator`.
* Fixed documentation for using a block in constructor call (added `dispatch` 
  method call)
* Updated `url` field for `CapybaraSelenium::AppServer::BaseConfiguration` to
  depend on host and port only if it is not a predefined value.
* Fixed usage with instance methods

## 0.0.2

* Complete refactoring for easy modular extension
* New application and selenium server configuration through configure methods
