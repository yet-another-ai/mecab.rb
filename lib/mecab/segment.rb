# frozen_string_literal: true

module Mecab
  # Ruby wrapper for the native extension
  class Segment
    attr_reader :model_argv

    # https://manpages.org/mecab for argument details
    # Example:
    # Mecab::Segment.new('-d /opt/homebrew/opt/mecab-ipadic/lib/mecab/dic/ipadic')
    def initialize(model_argv = "")
      @model_argv = model_argv

      _initialize(model_argv)
    end

    def cut(sentence)
      _cut(sentence)
    end
  end
end
