require "date_range_formatter"

RSpec.describe(DateRangeFormatter) do

  context "when the range begins and ends on the same date" do
    context "when neither times are specified" do
      it "takes the form of '<start date>'" do
        formatter = DateRangeFormatter.new("2009-11-1", "2009-11-1")
        expect(formatter.to_s).to eq("1st November 2009")
      end
    end

    context 'when only the start time is specified' do
      it "takes the form of '<start date> at <start time>'" do
        formatter = DateRangeFormatter.new("2009-11-1", "2009-11-1", "10:00")
        expect(formatter.to_s).to eq("1st November 2009 at 10:00")
      end
    end

    context 'when only the end time is specified' do
      it "takes the form of '<start date> until <end time>'" do
        formatter = DateRangeFormatter.new("2010-11-3", "2010-11-3", nil, "13:00")
        expect(formatter.to_s).to eq("3rd November 2010 until 13:00")
      end
    end

    context 'when both times are specified' do
      it "takes the form of '<start date> at <start time> to <end time>'" do
        formatter = DateRangeFormatter.new("2009-11-1", "2009-11-1", "10:00", "11:00")
        expect(formatter.to_s).to eq("1st November 2009 at 10:00 to 11:00")
      end
    end
  end

  context 'when the range begins and end with the same month' do
    context 'when neither times are specified' do
      it "takes the form of '<start day> - <end day> <month> <year>'" do
        formatter = DateRangeFormatter.new("2009-11-1", "2009-11-3")
        expect(formatter.to_s).to eq("1st - 3rd November 2009")
      end
    end

    context 'when only the start time is specified known' do
      it "takes the form of '<start date> at <start time> - <end date>'" do
        formatter = DateRangeFormatter.new("2009-11-1", "2009-11-3", "10:00")
        expect(formatter.to_s).to eq("1st November 2009 at 10:00 - 3rd November 2009")
      end
    end

    context 'when only the end time is specified' do
      it "takes the form of '<start date> - <end date> at <end time>'" do
        formatter = DateRangeFormatter.new("2009-11-1", "2009-11-3", nil, "14:00")
        expect(formatter.to_s).to eq("1st November 2009 - 3rd November 2009 at 14:00")
      end
    end

    context 'when both times are specified' do
      it "takes the form '<start date>' at '<start time> - <end date> at <end time>'" do
        formatter = DateRangeFormatter.new("2009-11-1", "2009-11-3", "10:00", "11:00")
        expect(formatter.to_s).to eq("1st November 2009 at 10:00 - 3rd November 2009 at 11:00")
      end
    end
  end

  context 'when the date range is within the same year' do
    context 'when neither times are specified' do
      it "takes the form '<start day> <start month> - <end day> <end month> <year>'" do
        formatter = DateRangeFormatter.new("2009-11-1", "2009-12-1")
        expect(formatter.to_s).to eq("1st November - 1st December 2009")
      end
    end

    context 'when only the start time is specified' do
      it "takes the form '<start date> at <start time> - <end date>'" do
        formatter = DateRangeFormatter.new("2009-11-1", "2009-12-1", "10:00")
        expect(formatter.to_s).to eq("1st November 2009 at 10:00 - 1st December 2009")
      end
    end

    context 'when only the end time is specified' do
      it "takes the form '<start date> - <end date> at <end time>'" do
        formatter = DateRangeFormatter.new("2009-10-2", "2009-12-5", nil, "11:00")
        expect(formatter.to_s).to eq("2nd October 2009 - 5th December 2009 at 11:00")
      end
    end

    context 'when both times are specified' do
      it "takes the form '<start date> at <start time> - <end date> at <end time>'" do
        formatter = DateRangeFormatter.new("2009-11-1", "2009-12-1", "10:00", "11:00")
        expect(formatter.to_s).to eq("1st November 2009 at 10:00 - 1st December 2009 at 11:00")
      end
    end
  end

  context 'when the date range spans more than 1 year' do
    context 'when neither times are specified' do
      it "takes the form '<start date> - <end date>'" do
        formatter = DateRangeFormatter.new("2009-11-1", "2010-12-1")
        expect(formatter.to_s).to eq("1st November 2009 - 1st December 2010")
      end
    end

    context 'when only the start time is specified' do
      it "takes the form '<start date> at <start time> - <end date>'" do
        formatter = DateRangeFormatter.new("2009-11-11", "2010-12-13", "10:00")
        expect(formatter.to_s).to eq("11th November 2009 at 10:00 - 13th December 2010")
      end
    end

    context 'when only the end time is specified' do
      it "takes the form '<start date> - <end date> at <end time>'" do
        formatter = DateRangeFormatter.new("2005-11-11", "2008-12-1", nil, "15:00")
        expect(formatter.to_s).to eq("11th November 2005 - 1st December 2008 at 15:00")
      end
    end

    context 'when both times are specified' do
      it "takes the form '<start date> at <start time> - <end date> at <end time>'" do
        formatter = DateRangeFormatter.new("2009-11-1", "2010-12-1", "10:00", "11:00")
        expect(formatter.to_s).to eq("1st November 2009 at 10:00 - 1st December 2010 at 11:00")
      end
    end
  end
end

