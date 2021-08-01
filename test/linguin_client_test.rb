# frozen_string_literal: true

require "test_helper"

class LinguinClientTest < Minitest::Test
  def test_that_client_raises_without_api_key
    client = Linguin::Client.new
    assert_raises(Linguin::AuthenticationError) { client.detect_language("test") }
    assert_raises(Linguin::AuthenticationError) { client.detect_language!("test") }
    assert_raises(Linguin::AuthenticationError) { client.detect_profanity("test") }
    assert_raises(Linguin::AuthenticationError) { client.detect_profanity!("test") }
    assert_raises(Linguin::AuthenticationError) { client.status }
  end

  def test_that_auth_header_is_set_with_api_key
    client = Linguin::Client.new("abc")
    assert_equal ({ "Authorization" => "Bearer abc" }), client.headers

    client = Linguin::Client.new
    client.api_key = "xyz"
    assert_equal ({ "Authorization" => "Bearer xyz" }), client.headers
  end
end
