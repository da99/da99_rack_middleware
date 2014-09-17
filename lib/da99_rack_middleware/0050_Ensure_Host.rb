
class Da99_Rack_Middleware

  class Ensure_Host

    def initialize new_app
      @app = new_app
    end

    def call e
      if Da99_Rack_Middleware::HOSTS.include?(e['SERVER_NAME']) ||
        ( 
         Da99_Rack_Middleware::HOSTS.include?(:localhost) &&
         e['SERVER_NAME'][/\A(localhost|127\.0\.0\.1)\z/]
        )
        return @app.call(e)
      end

      Da99_Rack_Middleware.response 444, :text, 'Unknown error.'
    end

  end # === class Ensure_Host


end # === class Da99_Rack_Middleware
