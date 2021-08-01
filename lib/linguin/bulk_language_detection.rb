# frozen_string_literal: true

module Linguin
  # == Linguin::BulkLanguageDetection
  # Returned by Linguin#detect_language(!) when called with an array of strings.
  #
  # #success? - Bool - checks if detection results were found
  # #error - Hash - contains `error` and `message` about what went wrong
  # #results - Array - contains the detection results for each text, ordered by confidence descending
  class BulkLanguageDetection < LanguageDetection; end
end
