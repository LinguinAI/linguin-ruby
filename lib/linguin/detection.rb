# frozen_string_literal: true

module Linguin
  # == Linguin::Detection
  # Returned by Linguin#detect(!).
  #
  # #success? - Bool - checks if detection results were found
  # #error - Hash - contains `error` and `message` about what went wrong
  # #results - Array - contains the detection results, ordered by confidence descending
  class Detection < BaseResponse
    attr_writer :success
    attr_accessor :results

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

      def success(results)
        new do |detection|
          detection.success = true
          detection.results = results[:results]
        end
      end
    end

    def success?
      !!@success
    end
  end
end
