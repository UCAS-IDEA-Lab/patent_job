class PatentDownloader
  def download_file
    temp = Tempfile.new('patents')
    tempname = temp.path
    temp.close
    Net::FTP.open('localhost', 'mfieldhouse', 'Nvidia%') do |ftp|
      ftp.getbinaryfile('test.csv', tempname)
    end
    tempname
  end
end