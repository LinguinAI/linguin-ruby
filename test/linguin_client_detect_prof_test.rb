# frozen_string_literal: true

require "test_helper"

class LinguinClientDetectProfTest < Minitest::Test
  def setup
    setup_profanity_detection_stub
    setup_bulk_profanity_detection_stub
    setup_profanity_detections_exceeded_stub
  end

  def setup_profanity_detection_stub
    # stub for successful detection
    mock_response = { score: 0.24335 }
    json_response = JSON.generate(mock_response)
    stub_request(:post, "https://api.linguin.ai/v2/detect/profanity")
      .with(body: { q: "test" })
      .to_return(
        status: 200,
        body: json_response,
        headers: { "Content-Type" => "application/json" }
      )
  end

  def setup_bulk_profanity_detection_stub
    # stub for successful bulk detection
    mock_response = { scores: [0.24335, 0.02344] }
    json_response = JSON.generate(mock_response)
    stub_request(:post, "https://api.linguin.ai/v2/bulk_detect/profanity")
      .with(body: { q: %w[test bahnsteig] })
      .to_return(
        status: 200,
        body: json_response,
        headers: { "Content-Type" => "application/json" }
      )
  end

  def setup_profanity_detections_exceeded_stub
    # stub for detection exceeding limit
    error_message = "Daily account detection limit exceeded"
    stub_request(:post, "https://api.linguin.ai/v2/detect/profanity")
      .with(body: { q: "testing too much" })
      .to_return(status: 429, body: error_message)
  end

  def test_that_empty_input_returns_input_error
    client = Linguin::Client.new("abcdef")
    ["", "   ", nil].each do |input|
      empty_detection = client.detect_profanity(input)

      assert_instance_of Linguin::ProfanityDetection, empty_detection
      assert !empty_detection.success?
      assert_equal 400, empty_detection.error[:code]
      assert_equal "Can an empty text have profanity in it? I doubt it.", empty_detection.error[:message]
    end
  end

  def test_that_empty_inputs_returns_input_error
    client = Linguin::Client.new("abcdef")
    ["", "   ", nil].each do |input|
      empty_detection = client.detect_profanity(["test", input])

      assert_instance_of Linguin::BulkProfanityDetection, empty_detection
      assert !empty_detection.success?
      assert_equal 400, empty_detection.error[:code]
      assert_equal "At least one of the texts provided was empty.", empty_detection.error[:message]
    end
  end

  def test_that_detect_returns_a_detection
    client = Linguin::Client.new("abc")
    response = client.detect_profanity("test")
    assert response.success?
    assert_equal 0.24335, response.score
  end

  def test_that_detect_with_array_returns_a_bulk_detection
    client = Linguin::Client.new("abc")
    response = client.detect_profanity(%w[test bahnsteig])
    assert response.success?
    assert_equal 2, response.scores.length
    assert_equal 0.24335, response.scores[0]
    assert_equal 0.02344, response.scores[1]
  end

  def test_that_detect_bang_raises_on_rate_limit_errors
    client = Linguin::Client.new("abc")
    assert_raises(Linguin::RateLimitError) { client.detect_profanity!("testing too much") }
  end
end
