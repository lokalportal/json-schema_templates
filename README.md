[![Build Status](https://travis-ci.org/lokalportal/json-schema_templates.svg?branch=master)](https://travis-ci.org/lokalportal/json-schema_templates)
[![Maintainability](https://api.codeclimate.com/v1/badges/42d06911ff938599c00a/maintainability)](https://codeclimate.com/github/lokalportal/json-schema_templates/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/42d06911ff938599c00a/test_coverage)](https://codeclimate.com/github/lokalportal/json-schema_templates/test_coverage)

# Json::SchemaTemplates

Built on top of [JSON::SchemaBuilder](https://github.com/parrish/json-schema_builder), `JSON::SchemaTemplates`
contains some quality of life improvements when writing JSON schemas for Rails applications.

It is based purely on Ruby classes, but handles them as templates and partials,
similar to ActionView in a lot of cases. This makes it easy to re-use
parts of schemas and even pass in locals to change partial behaviour.

It also allows setting default values for certain schema properties, e.g.
`additional_properties` when defining objects. This way, you don't have to 
include the argument in your schema every time, but instead only if you'd like
to override the default value.

Last but not least it defines a few new types, e.g. `datetime` as a shortcut for
`string format: 'date-time'`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'json-schema_templates'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json-schema_templates

## Usage

Schemas are defined as Ruby classes inside a module structure resembling a template path.
This means that all of your schemas reside in one root module, e.g. `Schemas`.

Let's take a look at the following example (found in `spec/support/examples/basic_types`):

```ruby
module Examples
  module BasicTypes
    class Schema < ::JSON::SchemaTemplates::Base
      schema do
        string :title, min_length: 5, required: true
        string :body, null: true
      end
    end
  end
end
```

The topmost module here is `Examples` which makes it our root module for schemas.  
To allow the Gem to actually search for schemas within this module, we have to set
the corresponding value in the configuration:

```ruby
JSON::SchemaTemplates.configure do |config|
  config.base_path = 'examples'
end
```

Notice that we didn't specify a module here, but rather a path, similar to rendering
templates in ActionView. The reason is that we are now able to handle everything within `Examples` as an actual
path: 

The above template's path is - based on its module hierarchy - `basic_types/schema` and we can 
render it using the helper method 

```ruby
JSON::SchemaTemplates.json_schema_for('basic_types/schema')
```

This README will be extended over time.  
Until then, please take a look at the [examples](https://github.com/lokalportal/json-schema_templates/tree/master/spec/support/examples)
for more information, e.g. on how to use partials in your schemas.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lokalportal/json-schema_templates. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Json::SchemaTemplates project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/json-schema_templates/blob/master/CODE_OF_CONDUCT.md).
