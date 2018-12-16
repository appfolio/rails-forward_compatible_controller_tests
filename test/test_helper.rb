# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../../test/dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require 'rails/forward_compatible_controller_tests'

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Use this method when asserting that the library raises exceptions
# When running tests in Rails 5 mode, no exception is raised (instead, Rails prints a deprecation warning)
# Therefore, we don't execute these assertions in Rails 5 mode.
def assert_raise_in_rails_4(exception)
  return unless ActionPack.gem_version < Gem::Version.new('5.0.0')

  assert_raise exception do
    yield
  end
end