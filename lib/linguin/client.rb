# frozen_string_literal: true

require "httparty"

module Linguin
  # == Linguin::Client
  # Is used internally when working with Linguin directly.
  # Can be instanciated to work with multiple clients.
  class Client
    include HTTParty

    base_uri "https://api.linguin.ai/v2"

    # we are parsing the JSON response in Linguin::BaseResponse
    # in order to have symbolized keys
    # see https://github.com/jnunemaker/httparty/tree/master/docs#parsing-json
    format :plain

    attr_accessor :headers

    def initialize(key = nil)
      configure_api_key(key)
    end

    def api_key=(key)
      configure_api_key(key)
    end

    def detect_language(text)
      ensure_api_key!

      return bulk_detect_language(text) if text.is_a?(Array)

      text = sanitize(text)

      if text.empty?
        return LanguageDetection.error(400,
                                       "The language of an empty text is more of a philosophical question.")
      end

      httparty_response = self.class.post("/detect/language", headers: headers, body: { q: text })
      LanguageDetection.from_httparty(response: httparty_response)
    end

    def detect_language!(text)
      detect_language(text).raise_on_error!
    end

    def detect_profanity(text)
      ensure_api_key!

      return bulk_detect_profanity(text) if text.is_a?(Array)

      text = text&.strip

      return ProfanityDetection.error(400, "Can an empty text have profanity in it? I doubt it.") if text.to_s.empty?

      httparty_response = self.class.post("/detect/profanity", headers: headers, body: { q: text })
      ProfanityDetection.from_httparty(response: httparty_response)
    end

    def detect_profanity!(text)
      detect_profanity(text).raise_on_error!
    end

    def status
      ensure_api_key!
      httparty_response = self.class.get("/status", headers: headers)
      Status.from_httparty(response: httparty_response)
    end

    def languages
      httparty_response = self.class.get("/languages")
      Languages.from_httparty(response: httparty_response)
    end

    private

    def bulk_detect_language(texts)
      texts = texts.map { |text| sanitize(text) }

      return BulkLanguageDetection.error(400, "At least one of the texts provided was empty.") if texts.any?(&:empty?)

      httparty_response = self.class.post("/bulk_detect/language", headers: headers, body: { q: texts })
      BulkLanguageDetection.from_httparty(response: httparty_response)
    end

    def bulk_detect_profanity(texts)
      texts.map! { |text| text.to_s.strip }

      return BulkProfanityDetection.error(400, "At least one of the texts provided was empty.") if texts.any?(&:empty?)

      httparty_response = self.class.post("/bulk_detect/profanity", headers: headers, body: { q: texts })
      BulkProfanityDetection.from_httparty(response: httparty_response)
    end

    def configure_api_key(key)
      @api_key = key
      self.headers = { "Authorization" => "Bearer #{key}" }
    end

    def ensure_api_key!
      raise Linguin::AuthenticationError, "Seems like you forgot to set Linguin.api_key" unless @api_key
    end

    def sanitize(text)
      text ||= ""
      text.to_s.strip
    end
  end
end
