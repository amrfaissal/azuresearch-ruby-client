# Ruby Client for Microsoft Azure Search

[![Build Status](https://travis-ci.org/amrfaissal/azuresearch-ruby-client.svg?branch=master)](https://travis-ci.org/amrfaissal/azuresearch-ruby-client)

## Description

This library brings Microsoft Azure Search to your Ruby/RoR application. It allows you to execute most common API requests against Azure Search.

## Requirements

- Ruby 2.0 or later.
- API key.

## Installation

Add this line to your application's Gemfile:

```
gem 'azure_search'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install azure_search
```

## Documentation

View the [reference documentation](http://www.rubydoc.info/gems/azure_search).

## Usage

The first thing to do is to create a `SearchIndexClient`. You typically create one client for your application.

Here's a complete example of creating a client, creating an index, adding documents, executing a search...etc.

```ruby
require 'azure_search'

include AzureSearch

client = SearchIndexClient.new("service-name", "index-name", "generated-api-key")

# Delete the index if it exists (Only for testing purposes)
client.delete unless !client.exists

# Index definition
index_def = {
  :name => "carshop",
  :fields => [
    IndexField.new("id", "Edm.String").searchable(true).key(true),
    IndexField.new("year", "Edm.String").searchable(true).retrievable(true),
    IndexField.new("make", "Edm.String").searchable(true).retrievable(true),
    IndexField.new("trim", "Edm.String").searchable(true).retrievable(true)
  ]
}
# Create the index with supplied index definition
client.create(index_def)

# Perform a batch insert of documents
ops = [
  IndexBatchOperation.upload({"id"=>1, "year"=>"2017", "make"=>"Audi", "model"=>"A3", "trim"=>"1.8 TFSI Premium 2dr Sedan"}),
  IndexBatchOperation.upload({"id"=>2, "year"=>"2017", "make"=>"Audi", "model"=>"A3", "trim"=>"2.0 TDI Premium 4dr Sedan"}),
  IndexBatchOperation.upload({"id"=>3, "year"=>"2016", "make"=>"Audi", "model"=>"A4", "trim"=>"2.0 TDI Premium 4dr Sedan"}),
  IndexBatchOperation.upload({"id"=>4, "year"=>"2016", "make"=>"Bentley", "model"=>"Mulsanne", "trim"=>"4dr Sedan"}),
  IndexBatchOperation.upload({"id"=>5, "year"=>"2016", "make"=>"Dodge", "model"=>"Dart", "trim"=>"Aero 4dr Sedan"})
]
client.batch_insert(ops, chunk_size=3)

# Perform a simple search for cars that are not of Audi make.
search_opts = IndexSearchOptions.new
                                .include_count(true)
                                .search_mode("all")
                                .search_fields("make,trim")
response = client.search("-audi", search_opts)
puts response

# Lookup the document with ID "1"
document = client.lookup("1")
puts document
```

## Contributing

Bug reports, Pull requests and Stars are always welcome. For bugs and feature requests, [please create an issue](https://github.com/amrfaissal/azuresearch-ruby-client/issues/new).

### Donate

* [![Donate](https://img.shields.io/badge/Donate-PayPal-blue.svg)](https://www.paypal.me/amrfaissal)
* Bitcoin: 1EdwqtXhojU4LGhTwBLT1JpTb1d71oA89o

![](https://cloud.githubusercontent.com/assets/1248967/25093965/2ea18cde-2395-11e7-8368-3f761b0bd8b7.png)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
