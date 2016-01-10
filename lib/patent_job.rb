require 'active_record'
require 'net/ftp'
require 'csv'
require 'pp'
require 'patent_downloader'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database  => "Patents.db"
)

class Patent < ActiveRecord::Base
  self.primary_key = 'person_id'
end

class PatentJob
  attr_reader :downloader 

  def initialize(downloader = PatentDownloader.new)
    @downloader = downloader
  end

  def run
    temp = downloader.download_file
    rows = parse(temp)
    update_patents(rows)
  end

  def parse(temp)
    string = File.read(temp)
    csv = CSV.new(string, headers: true, header_converters: :symbol)
    csv.to_a.map { |row| row.to_hash }
  end

  def update_patents(rows)
    Patent.connection.transaction {
      Patent.delete_all
      rows.each { |r| Patent.create!(r.to_hash)}
    }
  end
end
