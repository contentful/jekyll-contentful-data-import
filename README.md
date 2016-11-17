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
        space: cfexampleapi         # Required
        access_token: b4c0n73n7fu1  # Required
        cda_query:                  # Optional
          include: 2
          limit: 100
        all_entries: true           # Optional - Defaults to false, only grabbing the amount set on CDA Query
        all_entries_page_size: 1000 # Optional - Defaults to 1000, maximum amount of entries per CDA Request for all_entries
        content_types:              # Optional
          cat: MyCoolMapper
        client_options:             # Optional
          api_url: 'preview.contentful.com' # Defaults to 'api.contentful.com' which is Production
        base_path: app_path         # Optional - Defaults to Current directory
        destination: destination_in_data # Optional - Defaults to _data/contentful/spaces
```

Parameter             | Description
----------            | ------------
space                 | Contentful Space ID
access_token          | Contentful Delivery API access token
cda_query             | Hash describing query configuration. See [contentful.rb](https://github.com/contentful/contentful.rb) for more info (look for filter options there). Note that by default only 100 entries will be fetched, this can be configured to up to 1000 entries using the `limit` option.
all_entries           | Boolean, if true will run multiple queries to the API until it fetches all entries for the space
all_entries_page_size | Integer, the amount of maximum entries per CDA Request when fetching :all_entries
content_types         | Hash describing the mapping applied to entries of the imported content types
client_options        | Hash describing Contentful::Client configuration. See [contentful.rb](https://github.com/contentful/contentful.rb) for more info.
base_path             | String with path to your Jekyll Application, defaults to current directory. Path is relative to your current location.
destination           | String with path within _data under which to store the output yaml file. Defaults to contentful/spaces

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

### Hiding Space and Access Token in Public Repositories

In most cases you may want to avoid including your credentials in publicly available sites,
therefore you can do the following:

1. `bundle update`—make sure your gem version supports ENV_ variables

2. Set up your _config like so:

   ```yaml
   contentful:
     spaces:
       - example:
           space:        ENV_CONTENTFUL_SPACE_ID
           access_token: ENV_CONTENTFUL_ACCESS_TOKEN
   ```
   (Your Space ID will be looked upon on `ENV['CONTENTFUL_SPACE_ID']` and your Access Token
   on `ENV['CONTENTFUL_ACCESS_TOKEN']`.)

3. Either add the following variables to your shell's configuration file (.bashrc or .bash_profile, for example):

   ```bash
   export CONTENTFUL_ACCESS_TOKEN=abc123
   export CONTENTFUL_SPACE_ID=abc123
   ```
   (And run `source ~/.bashrc` or open new terminal to enable changes.)

   Or specify them on the command line:

   ```bash
   CONTENTFUL_ACCESS_TOKEN=abc123 CONTENTFUL_SPACE_ID=abc123 jekyll contentful
   ```
4. Party.

This way, it is safe to share your code without having to worry
about your credentials.

## Examples

You can find working examples of multiple uses [here](https://github.com/contentful/contentful_jekyll_examples).

## Contributing

Feel free to add your own examples by submitting a Pull Request. For more information,
please check [CONTRIBUTING.md](./CONTRIBUTING.md)
