require 'logger'
require './app'
require './lib/sensible_logging'

run sensible_logging(
  app: App,
  logger: Logger.new(STDOUT),
  log_tags: TaggedLogger.default_tags + [lambda { |req| [req.port] }],
  exclude_params: ['two']
)
