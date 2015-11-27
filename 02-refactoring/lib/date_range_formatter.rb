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
      return "#{format_prefix} to #{@end_time}" if @start_time && @end_time
      return "#{format_prefix}" if @start_time
      return "#{format_prefix} until #{@end_time}" if @end_time
      return format_suffix
    end

    if @start_time.nil? and @end_time.nil? and @start_date.year == @end_date.year
      return @start_date.strftime("#{@start_date.day.ordinalize}") +" - "+ format_suffix if @start_date.month == @end_date.month
      return @start_date.strftime("#{@start_date.day.ordinalize} %B") + " - " + format_suffix
    end

    "#{format_prefix} - #{format_suffix}"
  end

  private

  def format_prefix
    return section(@start_date, @start_time)
  end

  def format_suffix
    return section(@end_date, @end_time)
  end

  def section(date, time)
    return in_full(date) if time.nil?

    "#{in_full(date)} at #{time}"
  end

  def in_full(date)
    date.strftime("#{date.day.ordinalize} %B %Y")
  end
end

