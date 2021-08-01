# frozen_string_literal: true

module Linguin
  # == Linguin::BulkProfanityDetection
  # Returned by Linguin#detect_profanity(!) when called with an array of strings.
  #
  # #success? - Bool - checks if detection results were found
  # #error - Hash - contains `error` and `message` about what went wrong
  # #results - Array - contains the profanity scores of each text in the same order
  class BulkProfanityDetection < BaseResponse
    attr_writer :success
    attr_accessor :scores

    class << self
      def error(code, message)
        new do |detection|
          detection.success = false
          detection.error = {
            code: code,
            message: message
          }
        end
      end

      def success(result)
        new do |detection|
          detection.success = true
          detection.scores = result[:scores]
        end
      end
    end

    def success?
      !!@success
    end
  end
end
