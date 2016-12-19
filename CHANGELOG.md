# Change Log

## Unreleased
### Added

### v1.4.3
* Added use of `map_field` without localizing for custom mappers that map `sys` properties when `locale='*'` is being sent.

## v1.4.2
### Fixed
* Fixed localization issues for included assets [#29](https://github.com/contentful/jekyll-contentful-data-import/issues/29)

## v1.4.1
### Changed
* Changed `Location` fields to use strings as keys instead of symbols to make it consistent with the rest of the serialization
* Updated Contentful dependency to `~> 1.0`, which fixes localized includes

## v1.4.0
### Fixed
* Fix Locale support [#29](https://github.com/contentful/jekyll-contentful-data-import/issues/29)

### Added
* Allow override destination directory using the `destination` key in the configuration [#27](https://github.com/contentful/jekyll-contentful-data-import/pull/27)

## v1.3.0
### Added
* Added the possibility to use `space` and `access_token` from environment variables [#14](https://github.com/contentful/jekyll-contentful-data-import/issues/14)
* `all_entries` option to fetch entries over the 1000 limit of a single CDA request
* `all_entries_page_size` option to customize the size of the request for particularly heavy entries

## v1.2.1
### Fixed
* README showing incorrect configuration [#5](https://github.com/contentful/jekyll-contentful-data-import/issues/5)
* `client_options` being incorrectly parsed and allowing overriding parameters that should be fixed

## v1.2.0
### Added
* Customizable Data Path [#1](https://github.com/contentful/jekyll-contentful-data-import/issues/1)

## v1.1.0
### Added
* Nested Entries are now serialized completely

## v1.0.1
### Changed
* Content Type format is now as expected

## v1.0.0 [YANKED]
### Changed
* Content Types are separated in the Space YAML

## v0.1.1
### Changed

* Some documented as Optional parameters now truly Optional

## v0.1.0 [YANKED]

* Initial Release
