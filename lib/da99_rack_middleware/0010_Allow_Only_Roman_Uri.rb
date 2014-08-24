
class Da99_Rack_Middleware
  class Allow_Only_Roman_Uri

    def initialize new_app
      @app = new_app
    end

    def call new_env
      invalid = new_env['REQUEST_URI'][/[^a-zA-Z0-9\_\-\/\.\?\@\*]+/] 
      if invalid
        content = "Not found: #{new_env['REQUEST_URI']}\nReason: Invalid chars in page address."
        DA99.response 400, :text, content
      else
        @app.call new_env
      end
    end

  end # === Allow_Only_Roman_Uri
end # === Da99_Rack_Middleware
