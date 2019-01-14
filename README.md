# Sensible logging

[![CircleCI](https://circleci.com/gh/madetech/sensible_logging.svg?style=svg)](https://circleci.com/gh/madetech/sensible_logging) [![Gem Version](https://badge.fury.io/rb/sensible_logging.png)](http://badge.fury.io/rb/sensible_logging)


A logging library with sensible defaults for Sinatra apps.

## Features

* Add (or use an existing if present `X-Request-Id`) request ID for use in logs
* Trim the request logs to the bare minimal (inspired by lograge):
  * method
  * path
  * requesting IP address
  * status
  * duration
  * params if a `GET` request
* Tagged logging, with some sensible defaults:
  * severity
  * subdomain
  * environment
  * unique request ID

## Usage

1. Add `sensible_logging` to your `Gemfile` and use `bundle install`.
2. In `app.rb` register the module and then define your logging defaults.

```ruby
require 'sensible_logging'

class App < Sinatra::Base
  register Sinatra::SensibleLogging

  sensible_logging(
    logger: Logger.new(STDOUT)
    )

# rest of code omitted
```

### Available options

There are a number of options that you can pass into `sensible_logging`:

* `logger`: The logging object.  
  **Default**: `Logger.new(STDOUT)`
* `use_default_log_tags`: Includes the subdomain, `RACK_ENV` and unique request ID in the log tags.  
  **Default**: `true`
* `tld_length`: For example, if your domain was `www.google.com` this would result in `www` being tagged as your subdomain. If your domain is `www.google.co.uk`, set this value to `2` to correctly identify the subdomain as `www` rather than `www.google`.  
  **Default**: `1`.
* `log_tags`: An array of additional log tags to include. This can be strings, or you can include a `lambda` that will be evaluated. The `lambda` is passed a Rack `Request` object, and it must return an array of string values.  
  **Default**: `[]`
* `exclude_params`: An array of parameter names to be excluded from `GET` requests. By default, `GET` parameters are outputted in logs. If for example with the request `http://google.com/?one=dog&two=cat` you didn't want the `one` logged, you would set `exclude_params` to be `['one']`  
  **Default**: `[]`
* `include_log_severity`: Includes the log severity in the tagged output, such as `INFO`, `DEBUG` etc  
  **Default**: `true`

## Examples

There is an example Sinatra app included in this repo. Here's how to use it:

```shell
bundle install
cd examples
rackup
```

With the app running, run some curl commands against it:

```shell
curl 'localhost:9292/hello?one=two&two=three'
```

You should notice in the logs:

* Standard Sinatra `logger` helper works out of the box within apps with tags.
* Excluded parameters are not included, in this example `two` based on `config.ru`
* The request log is minimal compared to out of the box Sinatra.
* `env['request_id']` is now available to hook into Sentry reports.

## FAQ

### Why is the timestamp absent?

To quote [lograge][link_lograge] (which was the inspiration for this library):

> The syntax is heavily inspired by the log output of the Heroku router. It doesn't include any timestamp by default, instead, it assumes you use a proper log formatter instead.

## License

MIT

[link_lograge]: https://github.com/roidrage/lograge#lograge---taming-rails-default-request-logging
