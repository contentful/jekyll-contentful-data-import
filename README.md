# Jekyll-Contentful-Data-Import

[![Build Status](https://travis-ci.org/contentful/jekyll-contentful-data-import.svg?branch=master)](https://travis-ci.org/contentful/jekyll-contentful-data-import)

Jekyll-Contentful-Data-Import is a [Jekyll](http://jekyllrb.com/) extension to use the Jekyll static site generator together with the API-driven [Contentful CMS](https://www.contentful.com). It is powered by the [Contentful Ruby Gem](https://github.com/contentful/contentful.rb).

Experience the power of Jekyll while staying sane as a developer by letting end-users edit content in a web-based interface.

## Installation

Create a Gemfile in your Jekyll project and add the following:

```ruby
source 'https://rubygems.org'

group :jekyll_plugins do
  gem "jekyll-contentful-data-import"
end
```

Then as usual, run:

```bash
bundle install
```

## Usage

Run `jekyll contentful` in your terminal. This will fetch entries for the configured
spaces and content types and put the resulting data in the
[local data folder](http://jekyllrb.com/docs/datafiles/) as yaml files.

### --rebuild option

The `contentful` command has a `--rebuild` option which will trigger a rebuild of your site

## Configuration

To configure the extension, add the following configuration block to Jekyll's `_config.yml`:

```yaml
contentful:
  spaces:
    - example: # Jekyll _data folder identifier - Required
        space: cfexampleapi        # Required
        access_token: b4c0n73n7fu1 # Required
        cda_query:                 # Optional
          include: 2
          limit: 100
        content_types:             # Optional
          cat: MyCoolMapper
        client_options:            # Optional
          :preview: false
          :raise_errors: true
          :dynamic_entries: :auto
        base_path: app_path        # Optional - Defaults to Current directory

```

Parameter           | Description
----------          | ------------
space               | Contentful Space ID
access_token        | Contentful Delivery API access token
cda_query           | Hash describing query configuration. See [contentful.rb](https://github.com/contentful/contentful.rb) for more info (look for filter options there). Note that by default only 100 entries will be fetched, this can be configured to up to 1000 entries using the `limit` option.
content_types       | Hash describing the mapping applied to entries of the imported content types
client_options      | Hash describing Contentful::Client configuration. See [contentful.rb](https://github.com/contentful/contentful.rb) for more info.
base_path           | String with path to your Jekyll Application, defaults to current directory. Path is relative to your current location.

You can add multiple spaces to your configuration

## Entry mapping

The extension will transform every fetched entry before storing it as a yaml file in the local
data folder. If a custom mapper is not specified a default one will be used.

The default mapper will map fields, assets and linked entries.

### Custom Mappers

You can create your own mappers if you need to. The only requirement for a class to behave as a
mapper is to have a `map` instance method.

Following is an example of such custom mapper that adds all `sys` properties to the entry:

```ruby
class MySysMapper < ::Jekyll::Contentful::Mappers::Base
  def map
    result = super

    entry.sys.each do |k, v|
      name, value = map_field k, v
      result['sys'][name] = value
    end

    result
  end
end
```

#### Caveats

Jekyll itself only allows you to import code as plugins only for its recognized plugin entry points.
Therefore we need to use a custom [Rakefile](https://github.com/contentful/contentful_jekyll_examples/blob/master/examples/custom_mapper/example/Rakefile) to import the mapper and required files:

```ruby
require 'jekyll'
require 'jekyll-contentful-data-import'
require './_plugins/mappers'

desc "Import Contentful Data with Custom Mappers"
task :contentful do
  Jekyll::Commands::Contentful.process([], {}, Jekyll.configuration['contentful'])
end
```

Then proceed to run: `bundle exec rake contentful`

## Examples

You can find working examples of multiple uses [here](https://github.com/contentful/contentful_jekyll_examples).

## Contributing

Feel free to add your own examples by submitting a Pull Request. For more information,
please check [CONTRIBUTING.md](./CONTRIBUTING.md)
