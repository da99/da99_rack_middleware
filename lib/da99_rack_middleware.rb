
require 'rack/protection'

class Da99_Rack_Middleware

  HOSTS = []
  DA99 = self

  dir   = File.expand_path(File.dirname(__FILE__) + '/da99_rack_middleware')
  files = Dir.glob(dir + '/*.rb').sort
  Names = files.map { |file|
    base = File.basename(file).sub('.rb', '')
    require "da99_rack_middleware/#{base}"
    pieces = base.split('_')
    pieces.shift
    pieces.join('_').to_sym
  }

  class << self

    def config *args
      yield(self) if block_given?
      case args.length
      when 0
        # do nothing

      when 2

        case args.first

        when :host
          HOSTS.concat args.last

        else
          fail "Unknown args: #{args.inspect}"

        end # === case

      else
        fail "Unknown args: #{args.inspect}"
      end # === case

      self
    end # === def config

    def redirect new, code = 301
      res = Rack::Response.new
      res.redirect new, code
      res.finish
    end

    def response code, type, raw_content
      content = raw_content.to_s
      res = Rack::Response.new
      res.status = code.to_i
      res.headers['Content-Length'] = content.bytesize.to_s
      res.headers['Content-Type']   = 'text/plain'.freeze
      res.body = [content]
      res.finish
    end

  end # === class self

  def initialize main_app
    @app = Rack::Builder.new do

      use Rack::Lint
      use Rack::ContentLength
      use Rack::ContentType, "text/plain"
      use Rack::MethodOverride
      use Rack::Session::Cookie, secret: SecureRandom.urlsafe_base64(nil, true)
      use Rack::Protection

      Names.each { |name|
        use Da99_Rack_Middleware.const_get(name)
      }

      if ENV['IS_DEV']
        use Rack::CommonLogger
        use Rack::ShowExceptions
      end

      run main_app
    end
  end

  def call env
    @app.call env
  end

end # === class Da99_Rack_Middleware ===
