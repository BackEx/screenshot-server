require 'bundler'
Bundler.require(:default)
require 'sinatra/base'
require 'digest'
require 'uri'

DEFAULT_SIZE = '800px600px'
IMAGE_EXT = '.png'

TMP_DIR = './tmp/'

class Root < Sinatra::Base
  get '/' do
    if params[:url]
      url = URI.escape params[:url]
      file = TMP_DIR + Digest::SHA256.hexdigest(url) + IMAGE_EXT
      if File.exists?(file)
        STDERR.puts "Get from cache #{file}"
      else
        cmd = "phantomjs ./rasterize.js #{url} #{file} #{DEFAULT_SIZE}"
        STDERR.puts cmd
        system cmd
      end
      send_file(file, disposition: 'inline', filename: 'screenshot.png', last_modified: File.mtime(file), type: 'image/png')
    else
      "Give me an url"
    end
  end
end

run Root
