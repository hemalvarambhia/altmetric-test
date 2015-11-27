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
    return full_format if @start_time && @end_time
    return format_with_start_time if @start_time
    return format_with_end_time if @end_time
    return format_suffix if @start_date == @end_date
    return @start_date.strftime("#{@start_date.day.ordinalize}") +" - "+ full_end_date if @start_date.month == @end_date.month
    return @start_date.strftime("#{@start_date.day.ordinalize} %B") + " - " + full_end_date if @start_date.year == @end_date.year

    return"#{format_prefix} - #{format_suffix}"
  end

  private

  def full_format
    if @start_date == @end_date
      return "#{format_prefix} to #{@end_time}"
    end
    
    "#{format_prefix} - #{format_suffix}"
  end

  def format_with_start_time
    return "#{format_prefix}" if @start_date == @end_date

    "#{format_prefix} - #{format_suffix}"
  end

  def format_with_end_time
    return "#{format_prefix} until #{@end_time}" if @start_date == @end_date

    "#{format_prefix} - #{format_suffix}"
  end

  def format_prefix
    return full_start_date if @start_time.nil?

    "#{full_start_date} at #{@start_time}"
  end

  def format_suffix
    return full_end_date if @end_time.nil?

    "#{full_end_date} at #{@end_time}"
  end

  def full_start_date
    @start_date.strftime("#{@start_date.day.ordinalize} %B %Y")
  end

  def full_end_date
    @end_date.strftime("#{@end_date.day.ordinalize} %B %Y")
  end
end

