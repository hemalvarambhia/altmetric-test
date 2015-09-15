require "date"
require "fixnum"

class DateRangeFormatter
  def initialize(start_date, end_date, start_time = nil, end_time = nil)
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    @start_time = start_time
    @end_time = end_time
  end

  def to_s
    if @start_date == @end_date
      return "#{prefix} to #{@end_time}" if both_times_known?
      return "#{prefix} until #{@end_time}" if end_time_known?
      return prefix if start_time_known? or times_not_known?
    end

    if times_not_known? and @start_date.year == @end_date.year
      return @start_date.strftime("#{@start_date.day.ordinalize} - #{suffix}") if @start_date.month == @end_date.month
      return @start_date.strftime("#{@start_date.day.ordinalize} %B - #{suffix}")
    end

    return "#{prefix} - #{suffix}"
  end

  private

  def prefix
    section(@start_date, @start_time)
  end

  def suffix
    section(@end_date, @end_time)
  end

  def section(date, time)
    date_range_section = date_in_full(date)
    date_range_section << " at #{time}" if time

    date_range_section
  end

  def date_in_full(start_date)
    start_date.strftime("#{start_date.day.ordinalize} %B %Y")
  end

  def times_not_known?
    @start_time.nil? and @end_time.nil?
  end

  def both_times_known?
    start_time_known? and end_time_known?
  end

  def start_time_known?
    !@start_time.nil?
  end

  def end_time_known?
    !@end_time.nil?
  end
end

