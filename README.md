# Jekyll-Contentful-Data-Import

[![Build Status](https://travis-ci.org/contentful/jekyll-contentful-data-import.svg?branch=master)](https://travis-ci.org/contentful/jekyll-contentful-data-import)

[Contentful](https://www.contentful.com) provides a content infrastructure for digital teams to power content in websites, apps, and devices. Unlike a CMS, Contentful was built to integrate with the modern software stack. It offers a central hub for structured content, powerful management and delivery APIs, and a customizable web app that enable developers and content creators to ship digital products faster.

Jekyll-Contentful-Data-Import is a [Jekyll](http://jekyllrb.com/) extension to use the Jekyll static site generator together with [Contentful](https://www.contentful.com). It is powered by the [Contentful Ruby Gem](https://github.com/contentful/contentful.rb).

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
    - example:                              # Jekyll _data folder identifier - Required
        space: cfexampleapi                 # Required
        access_token: b4c0n73n7fu1          # Required
        environment: master                 # Optional
        cda_query:                          # Optional
          include: 2
          limit: 100
        all_entries: true                   # Optional - Defaults to false, only grabbing the amount set on CDA Query
        all_entries_page_size: 1000         # Optional - Defaults to 1000, maximum amount of entries per CDA Request for all_entries
        content_types:                      # Optional
          cat: MyCoolMapper
        client_options:                     # Optional
          api_url: 'preview.contentful.com' # Defaults to 'api.contentful.com' which is Production
          max_include_resolution_depth: 5   # Optional - Defaults to 20, maximum amount of levels to resolve includes
        base_path: app_path                 # Optional - Defaults to Current directory
        destination: destination_in_data    # Optional - Defaults to _data/contentful/spaces
        individual_entry_files: true        # Optional - Defaults to false
        rich_text_mappings:                 # Optional - Defaults to {}
          embedded-entry-block: MyEntryRenderer
```

Parameter              | Description
----------             | ------------
space                  | Contentful Space ID
access_token           | Contentful Delivery API access token
environment            | Space environment, defaults to `master`
cda_query              | Hash describing query configuration. See [contentful.rb](https://github.com/contentful/contentful.rb) for more info (look for filter options there). Note that by default only 100 entries will be fetched, this can be configured to up to 1000 entries using the `limit` option.
all_entries            | Boolean, if true will run multiple queries to the API until it fetches all entries for the space
all_entries_page_size  | Integer, the amount of maximum entries per CDA Request when fetching :all_entries
content_types          | Hash describing the mapping applied to entries of the imported content types
client_options         | Hash describing `Contentful::Client` configuration. See [contentful.rb](https://github.com/contentful/contentful.rb) for more info.
base_path              | String with path to your Jekyll Application, defaults to current directory. Path is relative to your current location.
destination            | String with path within `_data` under which to store the output yaml file. Defaults to contentful/spaces
individual_entry_files | Boolean, if true will create an individual file per entry separated in folders by content type, file path will be `{space_alias}/{content_type_id}/{entry_id}.yaml`. Default behavior is to create a file per space. Usage is affected when this is set to true, please look in the section below.
rich_text_mappings     | Hash with `'nodeTyoe' => RendererClass` pairs determining overrides for the [`RichTextRenderer` library](https://github.com/contentful/rich-text-renderer.rb) configuration.

You can add multiple spaces to your configuration

## Entry mapping

The extension will transform every fetched entry before storing it as a yaml file in the local
data folder. If a custom mapper is not specified a default one will be used.

The default mapper will map fields, assets and linked entries.

### Custom Mappers

You can create your own mappers if you need to. The only requirement for a class to behave as a
mapper is to have a `map` instance method.

Following is an example of such custom mapper that reverses all entry field IDs:

```ruby
class MyReverseMapper < ::Jekyll::Contentful::Mappers::Base
  def map
    result = super
    reversed_result = {}

    result.each do |k, v|
      reversed_result[k.reverse] = v
    end

    reversed_result
  end
end
```

#### Caveats

**Note:** This has changed since previous version.

When creating custom mappers, you should create them in a file under `#{source_dir}/_plugins/mappers/`.
This will allow the autoload mechanism that has been included in the latest version.

With the autoload mechanism, there is no longer a need to create a `rake` task for importing using custom mappers.

If you already have a custom `rake` task, the new autoload mechanism will not affect it from working as it was working previously.

### Rich Text *Beta*

To render rich text in your views, you can use the `rich_text` filter:

```liquid
{{ entry.rich_text_field | rich_text }}
```

This will output the generated HTML generated by the [`RichTextRenderer` library](https://github.com/contentful/rich-text-renderer.rb).

#### Adding custom renderers

When using rich text, if you're planning to embed entries, then you need to create your custom renderer for them. You can read how create your own renderer classes [here](https://github.com/contentful/rich-text-renderer.rb#using-different-renderers).

To configure the mappings, you need to add them in your `contentful` block like follows:

```yaml
contentful:
  spaces:
    - example:
      # ... all the regular config ...
      rich_text_mappings:
        embedded-entry-block: MyCustomRenderer
```

You can also add renderers for all other types of nodes if you want to have more granular control over the rendering.

This will use the same autoload strategy included for custom entry mappers, therefore, you should include your mapper classes in `#{source_dir}/_plugins/mappers/`.

#### Using the helper with multiple Contentful spaces

In case you have multiple configured spaces, and have different mapping configurations for them. You can specify which space you want to pull the configuration from when using the helper.

The helper receives an additional optional parameter for the space name. By default it is `nil`, indicating the first available space.

So, if for example you have 2 spaces with different configurations, to use the space called `foo`, you should call the helper as: `{{ entry.field | rich_text: "foo" }}`.

### Hiding Space and Access Token in Public Repositories

In most cases you may want to avoid including your credentials in publicly available sites,
therefore you can do the following:

1. `bundle update` — make sure your gem version supports `ENV_` variables

2. Set up your `_config` like so:

  ```yaml
  contentful:
    spaces:
      - example:
          space:        ENV_CONTENTFUL_SPACE_ID
          access_token: ENV_CONTENTFUL_ACCESS_TOKEN
          environment:  ENV_CONTENTFUL_ENVIRONMENT
  ```

  (Your Space ID will be looked upon on `ENV['CONTENTFUL_SPACE_ID']`, your Access Token on `ENV['CONTENTFUL_ACCESS_TOKEN']` and your environment on `ENV['CONTENTFUL_ENVIRONMENT']`.)

3. Either add the following variables to your shell's configuration file (.bashrc or .bash_profile, for example):

  ```bash
  export CONTENTFUL_ACCESS_TOKEN=abc123
  export CONTENTFUL_SPACE_ID=abc123
  export CONTENTFUL_ENVIRONMENT=master
  ```

  (And run `source ~/.bashrc` or open new terminal to enable changes.)

  Or specify them on the command line:

  ```bash
  CONTENTFUL_ACCESS_TOKEN=abc123 CONTENTFUL_SPACE_ID=abc123 CONTENTFUL_ENVIRONMENT=master jekyll contentful
  ```

4. Party.

This way, it is safe to share your code without having to worry
about your credentials.

### Using Multiple Entry Files

When setting the `individual_entry_files` flag to true, the usage pattern changes a little,
as Jekyll does not allow for variable unpacking when iterating.

A usage example is as follows:

```html
<ul class="cat-list">
  <!-- Each element in the array of entries for a content type is an array of the form ['entry_id', { ... entry_data ...}] -->
  {% for cat_data in site.data.contentful.spaces.example.cat %}
    {% assign cat_id = cat_data[0] %} <!-- Entry ID is the first element of the array -->
    {% assign cat = cat_data[1] %} <!-- Entry data is the second element of the array -->
    <li>
      <p>{{ cat_id }}: {{ cat.name }}</p>
    </li>
  {% endfor %}
</ul>
```

## Examples

You can find working examples of multiple uses [here](https://github.com/contentful/contentful_jekyll_examples).

## Contributing

Feel free to add your own examples by submitting a Pull Request. For more information,
please check [CONTRIBUTING.md](./CONTRIBUTING.md)
