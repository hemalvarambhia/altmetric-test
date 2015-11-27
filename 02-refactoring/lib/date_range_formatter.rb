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

    if @start_time.nil? and @end_time.nil?
      if @start_date.year == @end_date.year
        return @start_date.strftime("#{@start_date.day.ordinalize}") +" - "+ format_suffix if @start_date.month == @end_date.month
        return @start_date.strftime("#{@start_date.day.ordinalize} %B") + " - " + format_suffix
      end
    end

    "#{format_prefix} - #{format_suffix}"
  end

  private

  def format_prefix
    return start_date_in_full if @start_time.nil?

    "#{start_date_in_full} at #{@start_time}"
  end

  def format_suffix
    return end_date_in_full if @end_time.nil?

    "#{end_date_in_full} at #{@end_time}"
  end

  def start_date_in_full
    @start_date.strftime("#{@start_date.day.ordinalize} %B %Y")
  end

  def end_date_in_full
    @end_date.strftime("#{@end_date.day.ordinalize} %B %Y")
  end
end

