# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'speaking_clock'

class TestSpeakingClock < Minitest::Test
  def test_odd_formats
    assert_equal "one o'clock", SpeakingClock::Time.from_timestring('01:00')
    assert_raises(InvalidTimeStringError) { SpeakingClock::Time.from_timestring('0100') }
    assert_raises(InvalidTimeStringError) { SpeakingClock::Time.from_timestring('25:00') }
  end

  def test_special_times
    assert_equal "thirteen o'clock", SpeakingClock::Time.from_timestring('13:00')
    assert_equal 'twenty to midnight', SpeakingClock::Time.from_timestring('23:40')
    assert_equal 'half past noon', SpeakingClock::Time.from_timestring('12:30')
  end

  def test_full_times
    assert_equal 'midnight', SpeakingClock::Time.from_timestring('00:00')
    assert_equal 'noon', SpeakingClock::Time.from_timestring('12:00')
    assert_equal "one o'clock", SpeakingClock::Time.from_timestring('1:00')
  end

  def test_multiples_of_fifteen
    assert_equal 'half past seven', SpeakingClock::Time.from_timestring('7:30')
    assert_equal 'quarter to ten', SpeakingClock::Time.from_timestring('9:45')
    assert_equal 'quarter past four', SpeakingClock::Time.from_timestring('4:15')
  end

  def test_standard_time
    assert_equal 'six thirty two', SpeakingClock::Time.from_timestring('6:32')
  end

  def test_multiples_of_five
    assert_equal 'twenty five to eight', SpeakingClock::Time.from_timestring('7:35')
    assert_equal 'ten to eleven', SpeakingClock::Time.from_timestring('10:50')
    assert_equal 'twenty five past six', SpeakingClock::Time.from_timestring('6:25')
    assert_equal 'twenty past five', SpeakingClock::Time.from_timestring('5:20')

    # these here fail
    assert_equal 'twenty to eight', SpeakingClock::Time.from_timestring('8:40')
    assert_equal 'five to twelve', SpeakingClock::Time.from_timestring('11:55')
  end
end
