class Da99_Rack_Middleware
  class Always_Find_Favicon

    def initialize new_app
      @app = new_app
    end

    def call new_env

      status, headers, body = @app.call( new_env )

      if status === 404 &&
         !(new_env['PATH_INFO'][%r!\A/favicon\.ico!]) &&
         new_env['PATH_INFO']['favicon.ico']

        request  = Rack::Request.new(new_env)
        full_uri = request.url.split('/')[0,3]

        # Redirec to http[s]://domain.com/favicon.ico
        DA99.redirect '/favicon.ico', 301 # Permanent
      else
        [status, headers, body]
      end

    end

  end # === Allow_Only_Roman_Uri
end # === Da99_Rack_Middleware
