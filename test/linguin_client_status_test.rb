# frozen_string_literal: true

require "test_helper"

class LinguinClientTest < Minitest::Test
  def stub_with_json(mock_response)
    json_response = JSON.generate(mock_response)
    stub_request(:get, "https://api.linguin.ai/v2/status")
      .to_return(
        status: 200,
        body: json_response,
        headers: { "Content-Type" => "application/json" }
      )
  end

  def test_that_status_works
    stub_with_json({ status: { detections_today: 123, daily_limit: 50_000, remaining_today: 49_877 } })
    client = Linguin::Client.new("abc")
    response = client.status
    assert_equal 123, response.detections_today
    assert_equal 50_000, response.daily_limit
    assert_equal 49_877, response.remaining_today
  end

  def test_that_status_works_with_no_limits
    stub_with_json({ status: { detections_today: 123, daily_limit: -1, remaining_today: -1 } })
    client = Linguin::Client.new("abc")
    response = client.status
    assert_equal 123, response.detections_today
    assert_nil response.daily_limit
    assert_equal Float::INFINITY, response.remaining_today
  end

  def test_that_status_raises_on_internal_errors
    error_message = "Internal Server Error"
    stub_request(:get, "https://api.linguin.ai/v2/status").to_return(status: 500, body: error_message)
    client = Linguin::Client.new("abc")
    assert_raises(Linguin::InternalError) { client.status }
  end

  def test_that_status_raises_on_authentication_errors
    error_message = "API Key invalid"
    stub_request(:get, "https://api.linguin.ai/v2/status").to_return(status: 401, body: error_message)
    client = Linguin::Client.new("abc")
    assert_raises(Linguin::AuthenticationError) { client.status }
  end
end
