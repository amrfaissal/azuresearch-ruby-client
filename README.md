# Ruby Client for Microsoft Azure Search

[![Build Status](https://travis-ci.org/amrfaissal/azuresearch-ruby-client.svg?branch=master)](https://travis-ci.org/amrfaissal/azuresearch-ruby-client)

## Description

This library brings Microsoft Azure Search to your Ruby/RoR application. It allows you to execute most common API requests against Azure Search.

## Requirements

- Ruby 2.1 or later.
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

# Delete the index if it exists (Only in for testing purposes)
client.delete unless !client.exists

# Index definition
index_def = {
  :name => "carshop",
  :fields => [
    IndexField.new("ID", "Edm.String").searchable(true).key(true).to_hash,
    IndexField.new("CarName", "Edm.String").searchable(true).to_hash,
    IndexField.new("CarModel", "Edm.String").searchable(true).to_hash
  ]
}
# Create the index with supplied index definition
client.create(index_def)

# Perform a batch insert of documents
ops = [
  IndexBatchOperation.upload({"ID" => "1", "CarName" => "Audi A5", "CarModel" => "2017"}),
  IndexBatchOperation.upload({"ID" => "2", "CarName" => "Dacia", "CarModel" => "2013"}),
  IndexBatchOperation.upload({"ID" => "3", "CarName" => "Opel Astra", "CarModel" => "2016"}),
  IndexBatchOperation.upload({"ID" => "4", "CarName" => "Mercedes Benz", "CarModel" => "2017"}),
  IndexBatchOperation.upload({"ID" => "5", "CarName" => "Alpha Romeo", "CarModel" => "2015"})
]
client.batch_insert(ops, chunk_size=3)

# Perform a search request
search_opts = IndexSearchOptions.new.include_count(true).search_mode("all").search_fields("CarName,CarModel").top(3)
response = client.search("2017", search_opts)
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
