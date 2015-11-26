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
    
    if @start_date == @end_date
      full_start_date
    elsif @start_date.month == @end_date.month
      @start_date.strftime("#{@start_date.day.ordinalize} - #{@end_date.day.ordinalize} %B %Y")
    elsif @start_date.year == @end_date.year
      @start_date.strftime("#{@start_date.day.ordinalize} %B - ") + @end_date.strftime("#{@end_date.day.ordinalize} %B %Y")
    else
      "#{full_start_date} - #{full_end_date}"
    end
  end

  private

  def full_format
    if @start_date == @end_date
      return "#{format_prefix} to #{@end_time}"
    end
    
    "#{format_prefix} - #{full_end_date} at #{@end_time}"
  end

  def format_with_start_time
    return "#{format_prefix}" if @start_date == @end_date

    "#{format_prefix} - #{full_end_date}"
  end

  def format_with_end_time
    return "#{format_prefix} until #{@end_time}" if @start_date == @end_date

    "#{format_prefix} - #{full_end_date} at #{@end_time}"
  end

  def format_prefix
    return full_start_date if @start_time.nil?

    "#{full_start_date} at #{@start_time}"
  end

  def full_start_date
    @start_date.strftime("#{@start_date.day.ordinalize} %B %Y")
  end

  def full_end_date
    @end_date.strftime("#{@end_date.day.ordinalize} %B %Y")
  end
end

