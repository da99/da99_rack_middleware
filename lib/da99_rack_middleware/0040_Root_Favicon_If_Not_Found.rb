class Da99_Rack_Middleware
  class Root_Favicon_If_Not_Found

    NON_ROOT_ICO = /.+\/favicon\.ico\z/
    ROOT_ICO     = '/favicon.ico'

    def initialize new_app
      @app = new_app
    end

    def call e
      status, headers, body = @app.call( e )
      return [status, headers, body] unless status == 404 && e['PATH_INFO'][NON_ROOT_ICO]
      DA99.redirect ROOT_ICO, 302 # Permanent
    end

  end # === Root_Favicon_If_Not_Found
end # === Da99_Rack_Middleware
