require 'crypt/blowfish'
require 'digest/sha2'
require 'base64'
class Pict < Sequel::Model
  set_dataset :picts


  def self.take(crypto, w = 0, h = 0)
    pict = where(crypto_hash: crypto, width: w, height: h).first
    unless pict
      orig = load_original(crypto)
      p orig
      pict = create(crypto_hash: crypto, url: orig.url, width: w, height: h, original: false)
      img = GD2::Image.import(orig.path)
      # if img.aspect.to_f * h > w
      #   rszd = img.resize(w, 0)
      # else
      #   rszd = img.resize(0, h)
      # end
      rszd = img.resize(w, h)
      case File.extname(pict.url).downcase
      when '.jpg'
        buf = rszd.jpg(75)
      when '.png'
        buf = rszd.png
      when '.gif'
        buf = rszd.gif
      else
        buf = rszd.jpg(75)
      end
      FileUtils.mkdir_p(File.dirname(pict.path))
      File.open(pict.path, 'w'){|f| f.write(buf) }
    end
    pict
  end


#   def self.dc(bf, str)
#     cryptStream = StringIO.new(str)
#     plainStream = StringIO.new('')
#     chain = cryptStream.read(8)
#     plainStream.write(bf.decrypt_block(chain))

#     while (block = cryptStream.read(8))
#       decrypted = bf.decrypt_block(block)
#       plainText = decrypted ^ chain
#       plainStream.write(plainText) unless cryptStream.eof?
#       chain = block
#     end
#     p plainStream.string
#     plainStream.string
#   end

  def self.load_original(crypto)
    pict = Pict.where(crypto_hash: crypto, original: true).first
    unless pict
      key = Digest::MD5.digest(CONFIG['key'] || ENV['key'])
      bf = Crypt::Blowfish.new(key)

      # uri = dc(bf, Base64.urlsafe_decode64(crypto)).to_s.strip
      uri = bf.decrypt_string(Base64.urlsafe_decode64(crypto)).tap{|c| p c }.to_s.strip
      p uri
      res = Net::HTTP.get_response(URI(uri))
      if res.is_a?(Net::HTTPSuccess)
        pict = create(url: uri, crypto_hash: crypto, original: true, width: 0, height: 0)
        FileUtils.mkdir_p(File.dirname(pict.path))
        File.open(pict.path, 'w'){|f| f.write(res.body) }
        img = GD2::Image.import(pict.path)
        pict.update(width: img.size[0], height: img.size[1])
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
    File.join(CONFIG['storage'].to_s, (pk / 256 % 256).to_s, (pk % 256).to_s, pk.to_s + '-' + File.basename(url))
  end
end
