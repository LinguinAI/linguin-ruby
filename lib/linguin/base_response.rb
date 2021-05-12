# frozen_string_literal: true

module Linguin
  # == Linguin::BaseResponse
  # Base class for Linguin::Detection && Linguin::Status
  class BaseResponse
    CODE_MAP = {
      400 => InputError,
      401 => AuthenticationError,
      404 => NotFoundError,
      422 => InputError,
      429 => RateLimitError,
      500 => InternalError,
      503 => InternalError
    }.freeze

    attr_accessor :error

    def initialize
      yield self
    end

    class << self
      def from_httparty(response:)
        if response.code == 200
          response = JSON.parse response, symbolize_names: true
          success(response)
        else
          error(response.code, response.body)
        end
      end
    end

    def raise_on_error!
      return self unless error

      error_klass = CODE_MAP[error[:code]] || Error
      error_message = error[:message].empty? ? "unknown" : error[:message]
      raise error_klass, "#{error[:code]} / #{error_message}"
    end
  end
end
