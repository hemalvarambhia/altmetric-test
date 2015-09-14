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
    full_start_date = date_in_full(@start_date)
    full_end_date = date_in_full(@end_date)

    if both_times_known?
      return "#{full_start_date} at #{@start_time} to #{@end_time}" if @start_date == @end_date
      return "#{full_start_date} at #{@start_time} - #{full_end_date} at #{@end_time}"
    end

    if start_time_known?
      return "#{full_start_date} at #{@start_time}" if @start_date == @end_date
      return "#{full_start_date} at #{@start_time} - #{full_end_date}"
    end

    if end_time_known?
      return "#{full_start_date} until #{@end_time}" if @start_date == @end_date
      return "#{full_start_date} - #{full_end_date} at #{@end_time}"
    end

    if @start_date == @end_date
      full_start_date
    elsif @start_date.month == @end_date.month
      @start_date.strftime("#{@start_date.day.ordinalize} - #{date_in_full(@end_date)}")
    elsif @start_date.year == @end_date.year
      @start_date.strftime("#{@start_date.day.ordinalize} %B - ") + date_in_full(@end_date)
    else
      "#{full_start_date} - #{full_end_date}"
    end
  end

  private

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

