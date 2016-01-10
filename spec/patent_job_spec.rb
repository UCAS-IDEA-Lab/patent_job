require_relative '../lib/patent_job'

describe PatentJob do
  it "should download the csv file from the FTP server" do
    @job = PatentJob.new
    f = File.read(@job.download_file)
    expect(f).to satisfy("have 128 characters") { |v| v.length == 128 }
    expect(f).to include("Compress some things")
  end

  it "should replace existing patents with new patents" do
    @job = PatentJob.new
    @job.run
    expect(Patent.all.count).to eq(3)
  end
end