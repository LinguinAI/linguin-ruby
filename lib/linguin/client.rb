# frozen_string_literal: true

require "httparty"

module Linguin
  # == Linguin::Client
  # Is used internally when working with Linguin directly.
  # Can be instanciated to work with multiple clients.
  class Client
    include HTTParty

    base_uri "https://api.linguin.ai/v1"

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

    def detect(text)
      ensure_api_key!

      return bulk(text) if text.is_a?(Array)

      text = sanitize(text)

      return Detection.error(400, "The language of an empty text is more of a philosophical question.") if text.empty?

      httparty_response = self.class.post("/detect", headers: headers, body: { q: text })
      Detection.from_httparty(response: httparty_response)
    end

    def detect!(text)
      detect(text).raise_on_error!
    end

    def bulk(texts)
      texts = texts.map { |text| sanitize(text) }

      return BulkDetection.error(400, "At least one of the texts provided was empty.") if texts.any?(&:empty?)

      httparty_response = self.class.post("/bulk", headers: headers, body: { q: texts })
      BulkDetection.from_httparty(response: httparty_response)
    end

    def bulk!(texts)
      bulk(texts).raise_on_error!
    end

    def status
      ensure_api_key!
      httparty_response = self.class.get("/status", headers: headers)
      Status.from_httparty(response: httparty_response)
    end

    private

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
