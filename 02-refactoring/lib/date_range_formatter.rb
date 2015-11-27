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
    return in_full(@start_date) if @start_time.nil?

    "#{in_full(@start_date)} at #{@start_time}"
  end

  def format_suffix
    return in_full(@end_date) if @end_time.nil?

    "#{in_full(@end_date)} at #{@end_time}"
  end

  def in_full(date)
    date.strftime("#{date.day.ordinalize} %B %Y")
  end
end

