# frozen_string_literal: true

module Linguin
  # == Linguin::Languages
  # Returns a hash of supported languages.
  class Languages < BaseResponse
    class << self
      def error(code, message)
        new do |status|
          status.error = {
            code: code,
            message: message
          }
        end.raise_on_error!
      end

      def success(response)
        response
      end
    end
  end
end
