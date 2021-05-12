# frozen_string_literal: true

module Linguin
  # == Linguin::Status
  # Returned by Linguin#status.
  #
  # [:+detections_today+:] how many detections you performed today
  # [:+daily_limit+:] your daily detection limit (or false)
  # [:+remaining_today+:] detections remaining today (can be Float::INFINITY)
  class Status < BaseResponse
    attr_accessor :detections_today, :daily_limit, :remaining_today

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
        response = response[:status]
        detections_today = response[:detections_today].to_i
        daily_limit = response[:daily_limit] == -1 ? nil : response[:daily_limit].to_i
        remaining_today = response[:remaining_today] == -1 ? Float::INFINITY : response[:remaining_today].to_i
        new do |status|
          status.detections_today = detections_today
          status.daily_limit = daily_limit
          status.remaining_today = remaining_today
        end
      end
    end
  end
end
