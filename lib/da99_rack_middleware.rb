
require 'rack/protection'

class Da99_Rack_Middleware

  dir   = File.expand_path(File.dirname(__FILE__) + '/da99_rack_middleware')
  files = Dir.glob(dir + '/*.rb').sort
  Names = files.map { |file|
    base = File.basename(file).sub('.rb', '')
    require "da99_rack_middleware/#{base}"
    pieces = base.split('_')
    pieces.shift
    pieces.join('_').to_sym
  }

  def initialize main_app
    @app = Rack::Builder.new do

      use Rack::ContentLength
      use Rack::Session::Cookie, secret: SecureRandom.urlsafe_base64(nil, true)
      use Rack::Protection

      if ENV['IS_DEV']
        use Rack::ShowExceptions
      end

      Names.each { |name|
        use Object.const_get(name)
      }

      run main_app
    end
  end

  def call env
    @app.call env
  end

end # === class Da99_Rack_Middleware ===
