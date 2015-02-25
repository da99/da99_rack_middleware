
class Da99_Rack_Protect

  class Ensure_Host

    SERVER_NAME = 'SERVER_NAME'.freeze
    LOCALHOST   = /\A(localhost|127\.0\.0\.1)\z/
    HTT_HOST    = 'HTTP_HOST'.freeze

    def initialize new_app, *hosts
      @app = new_app
      @hosts = hosts
    end

    def call e
      name     = e[SERVER_NAME]
      host     = e[HTT_HOST]

      is_valid = @hosts.include?(name)

      if !is_valid
        is_local = @hosts.include?(:localhost) && name[LOCALHOST]
        is_valid = is_local
      end

      is_match = host[/\A#{name}(:\d+)?\z/]

      return @app.call(e) if is_valid && is_match
      Da99_Rack_Protect.response 444, :text, 'Invalid host specified by client.'
    end

  end # === class Ensure_Host


end # === class Da99_Rack_Protect
