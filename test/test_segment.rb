# frozen_string_literal: true

require "test_helper"

class TestSegment < Minitest::Test
  def setup
    @segment = Mecab::Segment.new
  end

  def test_segmenting_japanese_text
    text = "太郎はこの本を二郎を見た女性に渡した。"

    assert_equal %w[太郎 は この 本 を 二 郎 を 見 た 女性 に 渡し た 。], @segment.cut(text)
  end

  def test_segmenting_english_text
    text = "hello world"

    assert_equal %w[hello world], @segment.cut(text)
  end

  def test_segmenting_mixed_text
    text = "太郎はこの本を二郎を見た女性に渡した。hello world"

    assert_equal ["太郎", "は", "この", "本", "を", "二", "郎", "を", "見", "た", "女性", "に", "渡し", "た", "。",
                  "hello", "world"], @segment.cut(text)
  end
end
