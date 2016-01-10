require_relative '../lib/patent_job'

describe PatentJob do
  it "should replace existing patents with new patents" do
    downloader = double("Downloader")
    f = 'patents.csv'
    expect(downloader).to receive(:download_file).once.and_return(f)
    @job = PatentJob.new(downloader)
    @job.run
    expect(Patent.all.count).to eq(3)
  end
end