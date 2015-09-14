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
    as_string = "#{prefix} - #{suffix}"
    if both_times_known?
      return "#{prefix} to #{@end_time}" if @start_date == @end_date
    end

    if start_time_known?
      return "#{prefix}" if @start_date == @end_date
      return "#{prefix} - #{suffix}"
    end

    if end_time_known?
      return "#{prefix} until #{@end_time}" if @start_date == @end_date
    end

    if not both_times_known?
      return prefix if @start_date == @end_date
      return @start_date.strftime("#{@start_date.day.ordinalize} - #{suffix}") if @start_date.month == @end_date.month
      return @start_date.strftime("#{@start_date.day.ordinalize} %B - ") + suffix if @start_date.year == @end_date.year
    end

    return as_string
  end

  private

  def prefix
    date_range_prefix = date_in_full(@start_date)
    date_range_prefix << " at #{@start_time}" if start_time_known?

    date_range_prefix
  end

  def suffix
    date_range_suffix = date_in_full(@end_date)
    date_range_suffix << " at #{@end_time}" if end_time_known?

    date_range_suffix
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

  def date_in_full(start_date)
    start_date.strftime("#{start_date.day.ordinalize} %B %Y")
  end
end

