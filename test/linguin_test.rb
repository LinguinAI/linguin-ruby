# frozen_string_literal: true

require "test_helper"

class LinguinTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Linguin::VERSION
  end

  def test_that_it_raises_without_api_key_set
    Linguin.api_key = nil
    assert_raises(Linguin::AuthenticationError) { Linguin.detect("test") }
    assert_raises(Linguin::AuthenticationError) { Linguin.detect!("test") }
    assert_raises(Linguin::AuthenticationError) { Linguin.status }
  end

  def test_that_it_forwards_calls_to_default_client
    client = Minitest::Mock.new
    client.expect :detect, true, ["test"]
    client.expect :detect!, true, ["test"]
    client.expect :status, true
    Linguin.stub :default_client, client do
      assert Linguin.detect("test")
      assert Linguin.detect!("test")
      assert Linguin.status
    end
    client.verify
  end
end
