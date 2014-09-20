class Da99_Rack_Protect
  class Squeeze_Uri_Dots

    DOTS_AND_SLASHES = /(\.+\/)|(\/\.+)/
    DOTS = /\.\.+/

    def initialize new_app
      @app = new_app
    end

    # Using :REQUEST_URI includes query string
    def call new_env
      old = new_env['REQUEST_URI']
      new = new_env['REQUEST_URI'].gsub(DOTS_AND_SLASHES, '/'.freeze).gsub(DOTS, '.'.freeze)
      if new != old 
        DA99.redirect new, 301
      else
        @app.call new_env
      end
    end

  end # === Squeeze_Uri_Dots
end # === Da99_Rack_Protect
