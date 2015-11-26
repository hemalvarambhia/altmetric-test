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

    
    if @start_date == @end_date
      if @end_time
        "#{full_start_date} until #{@end_time}"
      else
        full_start_date
      end
    elsif @start_date.month == @end_date.month
      if @end_time
        "#{full_start_date} - #{full_end_date} at #{@end_time}"
      else
        @start_date.strftime("#{@start_date.day.ordinalize} - #{@end_date.day.ordinalize} %B %Y")
      end
    elsif @start_date.year == @end_date.year
      if @end_time
        "#{full_start_date} - #{full_end_date} at #{@end_time}"
      else
        @start_date.strftime("#{@start_date.day.ordinalize} %B - ") + @end_date.strftime("#{@end_date.day.ordinalize} %B %Y")
      end
    else
      if @end_time
        "#{full_start_date} - #{full_end_date} at #{@end_time}"
      else
        "#{full_start_date} - #{full_end_date}"
      end
    end
  end

  private

  def full_format
    if @start_date == @end_date
      return  "#{full_start_date} at #{@start_time} to #{@end_time}"
    end
    
    "#{full_start_date} at #{@start_time} - #{full_end_date} at #{@end_time}"
  end

  def format_with_start_time
    return "#{full_start_date} at #{@start_time}" if @start_date == @end_date

    "#{full_start_date} at #{@start_time} - #{full_end_date}"
  end

  def full_start_date
    @start_date.strftime("#{@start_date.day.ordinalize} %B %Y")
  end

  def full_end_date
    @end_date.strftime("#{@end_date.day.ordinalize} %B %Y")
  end
end

