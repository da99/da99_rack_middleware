class Da99_Rack_Middleware
  class No_Slash_Path_Ending

    METHODS = ['HEAD', 'GET']
    LAST_SLASH = /\/$/
    SLASH = '/'

    def initialize new_app
      @app = new_app
    end

    def call new_env

      ext = File.extname(new_env['PATH_INFO'])
      remove_slash = begin
                       new_env['PATH_INFO'] != SLASH &&
                         METHODS.include?(new_env['REQUEST_METHOD']) &&
                         new_env['PATH_INFO'][-1,1] == SLASH &&
                         ext === ''
                     end

      return(@app.call( new_env )) unless remove_slash

      req  = Rack::Request.new(new_env)
      response = Rack::Response.new

      qs = req.query_string.strip.empty? ? nil : req.query_string
      new = [ req.path_info.sub(LAST_SLASH, ''), qs ].compact.join('?')

      response.redirect( new, 301 ) # permanent
      response.finish

    end

  end # === Slashify_Path_Ending
end # === Da99_Rack_Middleware
