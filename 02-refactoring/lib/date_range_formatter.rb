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
      return "#{prefix} to #{@end_time}" if @start_time && @end_time
      return "#{prefix} until #{@end_time}" if @end_time
      return prefix
    end

    if @start_time.nil? and @end_time.nil? and same_year?
      return "#{@start_date.day.ordinalize} - #{format_suffix}" if same_month?
      day_and_month = @start_date.strftime("#{@start_date.day.ordinalize} %B")
      return day_and_month + " - " + format_suffix
    end

    "#{prefix} - #{format_suffix}"
  end

  private

  def prefix
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

  def same_year?
    @start_date.year == @end_date.year
  end

  def same_month?
    @start_date.month == @end_date.month
  end
end

