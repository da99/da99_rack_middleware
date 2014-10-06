
class Da99_Rack_Protect
  class Allow_Only_Roman_Uri

    INVALID       = /[^a-zA-Z0-9\_\-\/\.\?\@\*\=]+/
    INVALID_QUERY = /[^a-zA-Z0-9\_\-\/\.\?\@\*\=\(\)\%]+/

    def initialize new_app
      @app = new_app
    end

    def call new_env
      path_invalid = new_env['PATH_INFO'][INVALID]
      qs_invalid   = new_env['QUERY_STRING'][INVALID_QUERY]
      if path_invalid || qs_invalid
        content = "Page not found. \nReason: Invalid chars in page address: #{[path_invalid, qs_invalid].compact.join}"
        DA99.response 400, :text, content
      else
        @app.call new_env
      end
    end

  end # === Allow_Only_Roman_Uri
end # === Da99_Rack_Protect
