require 'crypt/blowfish'
require 'digest/sha2'
require 'base64'
class Pict < Sequel::Model
  set_dataset :picts

  def self.take(url)
    pict = where(url: url).first
    unless pict
      key = Digest::MD5.hexdigest(CONFIG['key'])
      p key
      bf = Crypt::Blowfish.new(key)

      uri = bf.decrypt_string(Base64.urlsafe_decode64(url))
      p uri
      res = Net::HTTP.get_response(URI(uri))
      if res.is_a?(Net::HTTPSuccess)
        p res['content-type']
        pict = create(url: url)
        FileUtils.mkdir_p(File.dirname(pict.path))
        File.open(pict.path, 'w'){|f| f.write(res.body) }
      else
        return nil
      end
    end
    pict
  end

  # def send_pic
  #   send_file(path, disposition: :inline, filename: File.basename(path))
  # end

  def path
    File.join(CONFIG['storage'].to_s, (pk / 256 % 256).to_s, (pk % 256).to_s, pk.to_s + '-' + url[0..15])
  end
end
