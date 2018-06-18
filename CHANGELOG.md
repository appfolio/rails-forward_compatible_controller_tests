# Changelog

## [Unreleased]

- Adds support for `format` in controller tests

## [2.2.0] - 2018-06-03

- Adds support for `flash` and `session` in controller tests

### Fixed

- Fixes issue where `headers` was incorrectly treated as a special keyword argument in controller tests

## [2.1.0] - 2018-04-30

- Allow inclusion of the gem in Rails 5. In which case the gem does nothing.

## [2.0.1] - 2017-08-10

### Fixed

- Raise exception with the proper message when calling `xhr` with
  `raise_exception` enabled.

## [2.0.0] - 2017-08-09

- Rename gem from Controller::Testing::Kwargs to Rails::ForwardCompatibleControllerTests

## [1.0.3] - 2017-08-09

### Fixed

- Fix issue where deprecation warnings are output when using the new syntax with nil headers or
  params

## [1.0.2] - 2017-08-09

### Fixed

- Output deprecation warnings by default -- this should have been the case previously
  but a typo prevented it from being so


## [1.0.1] - 2017-08-08

### Fixed

- Fix issue where deprecation warnings are output when using the new syntax


## [1.0.0] - 2017-08-08

### Added

- Deprecation warnings can be output when using the old syntax by calling
  `Controller::Testing::Kwargs.deprecate`
- Exceptions can be raised when using the old syntax by calling
  `Controller::Testing::Kwargs.raise_exception`


## [0.1.0] - 2017-06-03

Initial Release
