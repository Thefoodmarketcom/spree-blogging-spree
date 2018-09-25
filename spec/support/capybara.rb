require 'capybara/rails'
require 'capybara/rspec'

Capybara.server = :webrick
Capybara.javascript_driver = :selenium_chrome_headless