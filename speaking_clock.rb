# frozen_string_literal: true

require 'humanize'

class InvalidTimeStringError < StandardError; end

module SpeakingClock
  class Time
    def self.from_timestring(timestring)
      unless timestring.match(/^\d{1,2}:\d{2}$/)
        raise InvalidTimeStringError,
              "timestring #{timestring} has an invalid Format - expecting HH:MM or H:MM"
      end

      new(
        *timestring.split(':').map(&:to_i)
      ).to_s
    end

    def to_s
      return "#{spoken_hour} #{spoken_minute}" unless five_minute_step?

      if full_hour?
        return spoken_hour if twelve_hour_step?

        return "#{spoken_hour} o'clock"
      end

      "#{spoken_minute} #{spoken_proximity} #{spoken_hour}"
    end

    private

    def initialize(hour, minute)
      raise InvalidTimeStringError, "hour #{hour} is invalid" if hour > 23 || hour.negative?
      raise InvalidTimeStringError("minute #{minute} is invalid") if minute > 59 || minute.negative?

      @hour = hour
      @minute = minute
    end

    def full_hour?
      @minute.zero?
    end

    def quarter_step?
      (@minute % 15).zero?
    end

    def spoken_hour
      return @hour.humanize.gsub('-', ' ') unless five_minute_step?

      l_hour = spoken_proximity == 'past' ? @hour : (@hour + 1) % 24
      return 'midnight' if l_hour.zero?
      return 'noon' if l_hour == 12

      l_hour.humanize.gsub('-', ' ')
    end

    def spoken_minute
      return @minute.humanize.gsub('-', ' ') unless five_minute_step?

      return 'half' if @minute == 30
      return 'quarter' if [15, 45].include? @minute

      spoken_proximity == 'past' ? @minute.humanize.gsub('-', ' ') : (60 - @minute).humanize.gsub('-', ' ')
    end

    def spoken_proximity
      return @minute unless five_minute_step?

      @minute <= 30 ? 'past' : 'to'
    end

    def five_minute_step?
      (@minute % 5).zero?
    end

    def twelve_hour_step?
      (@hour % 12).zero?
    end
  end
end
