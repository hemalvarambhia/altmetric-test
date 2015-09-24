require 'csv'
require_relative './file_not_found'
require_relative './journal'
require_relative './issn'
class Journals
  include Enumerable
  extend Forwardable
  def_delegator :@journals, :[]
  def_delegator :@journals, :empty?
  def_delegator :@journals, :size

  def initialize(journals = [])
    @journals = journals || []
  end

  def find_journal_with required_issn
    find {|journal| journal.issn == required_issn }
  end

  def has_journal_with? issn
    any?{ |journal| journal.issn == issn }
  end

  def each &block
    @journals.each &block
  end

  def self.load_from(file_name)
    if not File.exists?(file_name)
      raise FileNotFound.new(file_name)
    end

    journals = CSV.read(file_name, {headers: true}).collect do |row|
      Journal.new(ISSN.new(row["ISSN"]), row["Title"])
    end

    return Journals.new(journals)
  end
end
