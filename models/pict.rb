class Pict < Sequel::Model
  set_dataset :picts

  def self.take(url)
    pict = where(url: url).first
    unless pict
      uri = URI(url)
      res = Net::HTTP.get_response(uri)
      p res
      if res.is_a?(Net::HTTPSuccess)
      p res.body
        pict = create(url: url)
        FileUtils.mkdir_p(File.dirname(pict.path))
        File.open(pict.path, 'w'){|f| f.write(res.body) }
      end
    end
    pict
  end

  def send_pic
    send_file(path, disposition: :inline, filename: File.basename(url))
  end

  def path
    File.join(CONFIG['storage'].to_s, (pk / 256 % 256).to_s, (pk % 256).to_s, File.basename(url))
  end
end
