# require "pictie/version"

require 'init_db'
class Pictie < Sinatra::Base
  register Sinatra::Namespace

  configure %i(development staging production) do
    enable :logging
  end

  namespace '/api/v1' do
    get '/picture/size/:sz' do |sz|
      url = URI.decode(params[:url])
      if url
        pict = Pict.take(url)
        p pict
        p pict.path
        send_file(pict.path, disposition: :inline, filename: File.basename(pict.url))
        # pict ? pict.send_pic : error(JSON.dump({error: 'Not found'}), 404)
      else
        error JSON.dump({error: 'invalid argument'})
      end
    end

    get '/picture' do
      url = URI.decode(params[:url])
      if url
        pict = Pict.take(url)
        p pict
        p pict.path
        send_file(pict.path, disposition: :inline, filename: File.basename(pict.url))
        # pict ? pict.send_pic : error(JSON.dump({error: 'Not found'}), 404)
      else
        error JSON.dump({error: 'invalid argument'})
      end
    end

    
  end


end
