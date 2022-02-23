# Rails::ForwardCompatibleControllerTests

Backport Rails 5 style controller/integration testing syntax using kwargs to Rails 4.  Supports minitest and rspec.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails-forward_compatible_controller_tests', require: false
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails-forward_compatible_controller_tests

At the appropriate spot in your `test_helper.rb`, `rails_helper.rb`, or similar file add the following line:

```ruby
require 'rails/forward_compatible_controller_tests'
```

If using rspec, add the following lines to your rspec config:

```ruby
config.include Rails::ForwardCompatibleControllerTests, type: :controller
config.include Rails::ForwardCompatibleControllerTests, type: :request
```

## Usage

Allows you to simultaneously use the old and new syntax while making HTTP calls to your controllers
in your test suite. So both:

```ruby
get #{url_or_action}, params, headers
xhr :post, #{url_or_action}, params, headers
```

and

```ruby
get #{url_or_action}, params: params, headers: headers
get #{url_or_action}, xhr: true, params: params, headers: headers
```

should work while you transition your test suite.

## Modes of Operation

Deprecation warnings will appear by default when executing statements that
utilize the old method. Deprecation warnings can be disabled by adding the
following to your appropriate test helper:

```ruby
Rails::ForwardCompatibleControllerTests.ignore
```

The above is useful if you simply want to support the Rails 5 syntax. If
instead you want to prevent new uses of the old syntax, add the following:

```ruby
Rails::ForwardCompatibleControllerTests.raise_exception
```

The above is useful when you're done coverting the syntax but are not yet ready
to make the switch to Rails 5.

## Development

After checking out the repo, run `bin/setup` to install dependencies.

This library uses [Appraisal](https://github.com/thoughtbot/appraisal) to run specs in Rails 4 and 5:
- `bundle exec appraisal actionpack-4.2 rake`.
- `bundle exec appraisal actionpack-5.0 rake`.

The library is a no-op when used with Rails 5 (it doesn't affect the implementation of controller tests). You can run the tests in Rails 5 mode to ensure that the behaviour native to Rails 5 is the same as the behaviour in Rails 4 with the library.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/appfolio/rails-forward_compatible_controller_tests.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

