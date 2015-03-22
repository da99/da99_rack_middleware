
require 'rack/protection'

class Da99_Rack_Protect

  DA99              = self

  # =================================================================
  #
  # I need to know if new middleware has been added
  # to `rack-protection` so it can be properly
  # used (or ignored) by Da99_Rack_Protect.
  #
  # =================================================================
  RACK_PROTECTS_DIR = File.join File.dirname(`gem which rack-protection`.strip), '/rack/protection'
  RACK_PROTECTS     = Dir.glob(RACK_PROTECTS_DIR + '/*').map { |f|
    File.basename(f).sub('.rb', '') 
  }.sort

  Ignore_Rack_Protects = %w{ base version escaped_params remote_referrer }
  Known_Rack_Protects = %w{
    authenticity_token
    form_token
    frame_options
    http_origin
    ip_spoofing
    json_csrf
    path_traversal
    remote_token
    session_hijacking
    xss_header
  }

  Rack_Protection_Names = {'ip_spoofing' => :IPSpoofing, 'xss_header'=>:XSSHeader}

  Unknown_Rack_Protects = RACK_PROTECTS - Known_Rack_Protects - Ignore_Rack_Protects

  if !Unknown_Rack_Protects.empty?
    fail "Unknown rack-protection middleware: #{Unknown_Rack_Protects.inspect}"
  end

  require 'rack/protection/base'
  Known_Rack_Protects.each { |name|
    require "rack/protection/#{name}"
    official_name = begin
                      Rack_Protection_Names[name] ||= name.split('_').map(&:capitalize).join.to_sym
                    end

    Rack::Protection.const_get(official_name)
  }
  # =================================================================

  dir   = File.expand_path(File.dirname(__FILE__) + '/da99_rack_protect')
  files = Dir.glob(dir + '/*.rb').sort
  Names = files.map { |file|
    base = File.basename(file).sub('.rb', '')
    require "da99_rack_protect/#{base}"
    pieces = base.split('_')
    pieces.shift
    pieces.join('_').to_sym
  }

  class << self

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
    @configs = configs = {:hosts=>[]}

    yield(self) if block_given?

    @app = Rack::Builder.new do

      use Rack::Lint
      use Rack::ContentLength
      use Rack::ContentType, "text/plain"
      use Rack::MethodOverride
      use Rack::Session::Cookie, secret: SecureRandom.urlsafe_base64(nil, true)

      Known_Rack_Protects.each { |name|
        use Rack::Protection.const_get(Rack_Protection_Names[name])
      }

      Names.each { |name|
        case name
        when :Ensure_Host
          use Da99_Rack_Protect.const_get(name), *(configs[:hosts])
        else
          use Da99_Rack_Protect.const_get(name)
        end
      }

      run main_app
    end

    @configs[:hosts].freeze
  end

  def config settings, *args
    case settings
    when :host
      @configs[:hosts].concat args
    else
      fail "Unknown args: #{args.inspect}"
    end # === case

    self
  end # === def config

  def call env
    @app.call env
  end

end # === class Da99_Rack_Protect ===
