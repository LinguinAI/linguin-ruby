# frozen_string_literal: true

require "test_helper"

class LinguinClientTest < Minitest::Test
  def setup
    setup_detection_stub
    setup_bulk_detection_stub
    setup_status_stub
  end

  def setup_detection_stub
    # stub for successful detection
    mock_response = { results: [{ lang: "en", confidence: 0.87 }, { lang: "de", confidence: 0.23 }] }
    json_response = JSON.generate(mock_response)
    stub_request(:post, "https://api.linguin.ai/v1/detect")
      .with(body: { q: "test" })
      .to_return(
        status: 200,
        body: json_response,
        headers: { "Content-Type" => "application/json" }
      )
  end

  def setup_bulk_detection_stub
    # stub for successful bulk detection
    mock_response = { results: [[{ lang: "en", confidence: 0.87 }], [{ lang: "de", confidence: 0.92 }]] }
    json_response = JSON.generate(mock_response)
    stub_request(:post, "https://api.linguin.ai/v1/bulk")
      .with(body: { q: %w[test bahnsteig] })
      .to_return(
        status: 200,
        body: json_response,
        headers: { "Content-Type" => "application/json" }
      )
  end

  def setup_status_stub
    # stub for detection exceeding limit
    error_message = "Daily account detection limit exceeded"
    stub_request(:post, "https://api.linguin.ai/v1/detect")
      .with(body: { q: "testing too much" })
      .to_return(status: 429, body: error_message)
  end

  def test_that_empty_input_returns_input_error
    client = Linguin::Client.new("abcdef")
    ["", "   ", nil].each do |input|
      empty_detection = client.detect(input)

      assert_instance_of Linguin::Detection, empty_detection
      assert !empty_detection.success?
      assert_equal 400, empty_detection.error[:code]
      assert_equal "The language of an empty text is more of a philosophical question.", empty_detection.error[:message]
    end
  end

  def test_that_empty_inputs_returns_input_error
    client = Linguin::Client.new("abcdef")
    ["", "   ", nil].each do |input|
      empty_detection = client.detect(["test", input])

      assert_instance_of Linguin::BulkDetection, empty_detection
      assert !empty_detection.success?
      assert_equal 400, empty_detection.error[:code]
      assert_equal "At least one of the texts provided was empty.", empty_detection.error[:message]
    end
  end

  def test_that_detect_returns_a_detection
    client = Linguin::Client.new("abc")
    response = client.detect("test")
    assert response.success?
    assert_equal 2, response.results.length
    assert_equal "en", response.results[0][:lang]
    assert_equal 0.87, response.results[0][:confidence]
  end

  def test_that_detect_with_array_returns_a_bulk_detection
    client = Linguin::Client.new("abc")
    response = client.detect(%w[test bahnsteig])
    result_one = response.results[0]
    assert response.success?
    assert_equal 2, response.results.length
    assert_equal "en", result_one[0][:lang]
    assert_equal 0.87, result_one[0][:confidence]
  end

  def test_that_detect_bang_raises_on_rate_limit_errors
    client = Linguin::Client.new("abc")
    assert_raises(Linguin::RateLimitError) { client.detect!("testing too much") }
  end
end
