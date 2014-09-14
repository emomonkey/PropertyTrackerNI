# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
#ActiveRecord::Migration.maintain_test_schema!


RSpec.configure do |config|
  config.before(:suite) do
    config.use_transactional_fixtures = false
    DatabaseCleaner.clean_with :truncation

  end

  config.after(:suite) do
    DatabaseCleaner.clean
  end


  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
    load "#{Rails.root}/db/testseeds.rb"
  end

  config.after(:each) do
    DatabaseCleaner.clean


  end

  config.around do |example|
    # For examples using capybara-webkit for example.
    # Remove this if you don't use it or anything similar
    if example.metadata[:js]
      example.run

      ActiveRecord::Base.connection.execute("TRUNCATE #{ActiveRecord::Base.connection.tables.join(',')} RESTART IDENTITY")
    else
      ActiveRecord::Base.transaction do
        example.run
        raise ActiveRecord::Rollback
      end
    end
  end
end


