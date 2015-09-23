require 'csv'
require_relative './file_not_found'
require_relative './journal'
require_relative './issn'
class Journals
  include Enumerable
  extend Forwardable
  def_delegator :@journals, :[]


  def initialize journals
    @journals = journals || []
  end

  def find_journal_for required_issn
    find {|journal| journal.issn == required_issn }
  end

  def all
    @journals
  end

  def each &block
    @journals.each &block
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
