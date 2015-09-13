require 'csv'
require_relative './file_not_found'
require_relative './journal'
require_relative './issn'
class Journals
  def initialize journals
    @journals = journals || []
  end
  
  def find_journal_for required_issn
    @journals.detect{|journal|
      journal.issn == required_issn
    }
  end

  def first
    @journals.first
  end

  def last
    @journals.last
  end

  def all
    @journals
  end

  def empty?
    @journals.empty?
  end

  def size
    @journals.size
  end
  
  def self.load_from(file_name)
    if not File.exists?(file_name)
      raise FileNotFound.new(file_name)
    end
    
    journals = []
    CSV.foreach(file_name, {headers: true}) do |csv_row|
      journals << Journal.new(
        ISSN.new(csv_row["ISSN"]),
        csv_row["Title"])
    end

    return Journals.new(journals)
  end
end
