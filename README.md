# Linguin AI Ruby wrapper

[![Gem Version](https://badge.fury.io/rb/linguin.svg)](https://badge.fury.io/rb/linguin) ![build](https://github.com/LinguinAI/linguin-ruby/actions/workflows/main.yml/badge.svg) [![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/testdouble/standard)

This is a Ruby wrapper for the [Linguin AI](https://linguin.ai) API (see [API docs](https://linguin.ai/api-docs/v2)) providing Language and Profanity Detection as a Service.

Linguin AI is free for up to 100 detections per day. You can get your API key [here](https://linguin.ai).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "linguin"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install linguin

## Usage

Use the Linguin singleton to get started with just a few lines of code:

```ruby
require "linguin"

Linguin.api_key = "YOUR-API-KEY" # goto https://linguin.ai to get your key

response = Linguin.detect_language("test")
response.success? # => true
response.results  # => [{ lang: "en", confidence: 0.97 }, ...]

response = Linguin.detect_profanity("you are a moron")
response.success? # => true
response.score    # => 0.998
```

If something goes wrong (here: empty text):

```ruby
response = Linguin.detect_language("")
response.success? # => false
response.error
# => { code: 400, message: "The language of an empty text is more of a philosophical question." }

# if you prefer to handle exceptions instead you can use `#detect_language!`:
response = Linguin.detect_language!("")
# => raises Linguin::InputError
```

See the list of all exceptions [here](https://github.com/LinguinAI/linguin-ruby/blob/main/lib/linguin/exceptions.rb).

### Bulk detection

To detect the language of multiple texts with one API call, you can pass them as an array. The results will be returned in the same order as the texts.
All texts have to not be empty. Using `detect_language!` will result in an exception as for single detections.

The same is true for profanity detection: calling `detect_profanity!` with empty texts will result in an exception as for single detections.

```ruby
response = Linguin.detect_language(["test", "bahnhof", "12341234"])
response.results
# => [ [{ lang: "en", confidence: 0.97 }, ...], [{ ... }], [] ]

response = Linguin.detect_profanity(["a test", "you are a moron"])
response.scores
# => [0.0124, 0.9981]

response = Linguin.detect_language(["test", ""])
response.success? # => false
response.error
# => { code: 400, message: "At least one of the texts provided was empty." }

Linguin.detect_language!(["test", ""])
# => raises Linguin::InputError
```

### Account status

You can fetch the status of your account:

```ruby
status = Linguin.status
status.detections_today # => 4_500
status.daily_limit      # => 50_000 or nil for no limit
status.remaining_today  # => 45_500 or Float::INFINITY for unlimited
```

### Language list

You can fetch the list of supported languages:

```ruby
languages = Linguin.languages
# => { de: ["German", "Deutsch"], ... }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/LinguinAI/linguin-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/LinguinAI/linguin-ruby/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Linguin project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/LinguinAI/linguin-ruby/blob/master/CODE_OF_CONDUCT.md).
