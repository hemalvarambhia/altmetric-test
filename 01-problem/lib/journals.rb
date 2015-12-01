require 'csv'
require_relative './file_not_found'
require_relative './journal'
require_relative './issn'
# A class to model the concept of a collection/repository
# of journals
class Journals
  include Enumerable
  extend Forwardable
  def_delegators :@journals, :[], :empty?, :size

  def initialize(journals = [])
    @journals = journals || []
  end

  def find_journal_with(required_issn)
    find { |journal| journal.issn == required_issn }
  end

  def journal_with?(issn)
    any? { |journal| journal.issn == issn }
  end

  def each(&block)
    @journals.each(&block)
  end

  def load_from(file_name)
    fail FileNotFound, file_name unless File.exist?(file_name)

    CSV.read(file_name, headers: true).each do |row|
      @journals << Journal.new(ISSN.new(row['ISSN']), row['Title'])
    end
  end
end
