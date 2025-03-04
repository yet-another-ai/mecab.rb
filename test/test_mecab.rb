# frozen_string_literal: true

require "test_helper"

class TestMecab < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Mecab::VERSION
  end

  def test_it_has_a_cpp_version_number
    refute_nil ::Mecab::CPP_VERSION
  end
end
