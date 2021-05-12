# frozen_string_literal: true

module Linguin
  # == Linguin::BulkDetection
  # Returned by Linguin#detect(!) when called with an array of strings.
  #
  # #success? - Bool - checks if detection results were found
  # #error - Hash - contains `error` and `message` about what went wrong
  # #results - Array - contains the detection results for each text, ordered by confidence descending
  class BulkDetection < Detection; end
end
