require_relative '../lib/patent_downloader'

describe PatentDownloader do
  it "should download the csv file from the FTP server" do
    @conn = PatentDownloader.new
    f = File.read(@conn.download_file)
    expect(f).to satisfy("have 128 characters") { |v| v.length == 128 }
    expect(f).to include("Compress some things")
  end
end