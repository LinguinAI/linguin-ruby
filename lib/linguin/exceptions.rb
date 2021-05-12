# frozen_string_literal: true

module Linguin
  class Error < StandardError; end
  class InputError < Error; end
  class NotFoundError < Error; end
  class AuthenticationError < Error; end
  class RateLimitError < Error; end
  class InternalError < Error; end
end
