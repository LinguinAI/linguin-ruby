# frozen_string_literal: true

module Linguin
  # == Linguin::Status
  # Returned by Linguin#status.
  #
  # [:+detections_today+:] how many detections you performed today
  # [:+daily_limit+:] your daily detection limit (or false)
  # [:+remaining_today+:] detections remaining today (can be Float::INFINITY)
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
