# frozen_string_literal: true

require_relative "linguin/version"
require_relative "linguin/exceptions"
require_relative "linguin/client"
require_relative "linguin/base_response"
require_relative "linguin/language_detection"
require_relative "linguin/profanity_detection"
require_relative "linguin/bulk_language_detection"
require_relative "linguin/bulk_profanity_detection"
require_relative "linguin/status"
require_relative "linguin/languages"

# == Linguin API wrapper module
# Can be used as a singleton to access all API methods.
# Alternatively, Linguin::Client can be instantiated.
#
# = Linguin.detect
# [:+text+:] The text to be used for language detection.
# Attempts to detect the language of the given text.
# Returns a Linguin::Response object.
#
# = Linguin.detect!
# [:+text+:] The text to be used for language detection.
# Just like #detect but raises an exception if anything goes wrong.
#
# = Linguin.status
# Returns the status of your Linguin account as Linguin::Status
# * number of requests today
# * daily detection limit of your account (false for unlimited)
# * remaining detections today (can be Infinity)
#
# = Linguin.languages
# Returns the list of supported languages.
module Linguin
  class << self
    def api_key=(api_key)
      default_client.api_key = api_key
    end

    def detect_language(text)
      default_client.detect_language(text)
    end

    def detect_language!(text)
      default_client.detect_language!(text)
    end

    def detect_profanity(text, lang = nil)
      default_client.detect_profanity(text, lang)
    end

    def detect_profanity!(text, lang = nil)
      default_client.detect_profanity!(text, lang)
    end

    def status
      default_client.status
    end

    def languages
      default_client.languages
    end

    private

    def default_client
      @default_client ||= Client.new
    end
  end
end
