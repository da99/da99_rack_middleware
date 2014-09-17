
class Da99_Rack_Middleware

  class Ensure_Host

    SERVER_NAME = 'SERVER_NAME'
    LOCALHOST   = /\A(localhost|127\.0\.0\.1)\z/
    HTT_HOST    = 'HTTP_HOST'

    def initialize new_app
      @app = new_app
    end

    def call e
      hosts    = Da99_Rack_Middleware::HOSTS
      name     = e[SERVER_NAME]
      host     = e[HTT_HOST]

      is_valid = hosts.include?(name)

      if !is_valid
        is_local = hosts.include?(:localhost) && name[LOCALHOST]
        is_valid = is_local
      end

      is_match = host[/\A#{name}(:\d+)?\z/]

      return @app.call(e) if is_valid && is_match
      Da99_Rack_Middleware.response 444, :text, 'Unknown error.'
    end

  end # === class Ensure_Host


end # === class Da99_Rack_Middleware
