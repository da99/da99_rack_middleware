
class Da99_Rack_Protect

  class No_Old_MSIE

    UA = /; MSIE (\d)\.\d/
    def initialize new_app
      @app = new_app
    end

    def call e
      if e['HTTP_USER_AGENT'].to_s[UA] && $1.to_i < 9
        return DA99.response 400, :text, "Page inaccessible because you are using an old browser: MSIE #{$1}"
      end
      @app.call e
    end

  end # === class No_Old_MSIE


end # === class Da99_Rack_Protect
