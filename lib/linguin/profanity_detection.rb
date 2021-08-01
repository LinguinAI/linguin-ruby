# frozen_string_literal: true

module Linguin
  # == Linguin::ProfanityDetection
  # Returned by Linguin#detect_profanity(!).
  #
  # #success? - Bool - checks if detection results were found
  # #error - Hash - contains `error` and `message` about what went wrong
  # #result - Float - profanity score 0.0..1.0
  class ProfanityDetection < BaseResponse
    attr_writer :success
    attr_accessor :score

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
          detection.score = result[:score]
        end
      end
    end

    def success?
      !!@success
    end
  end
end
