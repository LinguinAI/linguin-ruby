# frozen_string_literal: true

require "test_helper"

class LinguinTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Linguin::VERSION
  end

  def test_that_it_raises_without_api_key_set
    Linguin.api_key = nil
    assert_raises(Linguin::AuthenticationError) { Linguin.detect_language("test") }
    assert_raises(Linguin::AuthenticationError) { Linguin.detect_language!("test") }
    assert_raises(Linguin::AuthenticationError) { Linguin.detect_profanity("test") }
    assert_raises(Linguin::AuthenticationError) { Linguin.detect_profanity!("test") }
    assert_raises(Linguin::AuthenticationError) { Linguin.status }
  end

  def test_that_it_forwards_calls_to_default_client
    client = Minitest::Mock.new
    client.expect :detect_language, true, ["test"]
    client.expect :detect_language!, true, ["test"]
    client.expect :detect_profanity, true, ["test", nil]
    client.expect :detect_profanity!, true, ["test", nil]
    client.expect :status, true
    client.expect :languages, true
    Linguin.stub :default_client, client do
      assert Linguin.detect_language("test")
      assert Linguin.detect_language!("test")
      assert Linguin.detect_profanity("test")
      assert Linguin.detect_profanity!("test")
      assert Linguin.status
      assert Linguin.languages
    end
    client.verify
  end
end
