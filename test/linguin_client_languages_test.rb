# frozen_string_literal: true

require "test_helper"

class LinguinLanguagesTest < Minitest::Test
  def stub_with_json(mock_response)
    json_response = JSON.generate(mock_response)
    stub_request(:get, "https://api.linguin.ai/v1/languages")
      .to_return(
        status: 200,
        body: json_response,
        headers: { "Content-Type" => "application/json" }
      )
  end

  def test_that_languages_works
    stub_with_json({ en: %w[English English], de: %w[German Deutsch], ar: %w[Arabic العربية] })
    client = Linguin::Client.new("abc")
    response = client.languages
    assert_equal "English", response[:en][0]
    assert_equal "Deutsch", response[:de][1]
    assert_equal "العربية", response[:ar][1]
  end
end
