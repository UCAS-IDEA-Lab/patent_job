require 'active_record'
require 'net/ftp'
require 'csv'
require 'pp'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database  => "Patents.db"
)

class Patent < ActiveRecord::Base
  self.primary_key = 'person_id'
end

class PatentJob
  def run
    temp = download_file
    rows = parse(temp)
    update_patents(rows)
  end

  def download_file
    temp = Tempfile.new('patents')
    tempname = temp.path
    temp.close
    Net::FTP.open('localhost', 'mfieldhouse', 'Nvidia%') do |ftp|
      ftp.getbinaryfile('test.csv', tempname)
    end
    tempname
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
