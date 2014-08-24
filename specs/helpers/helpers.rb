
require 'Bacon_Colored'
require 'pry'
require 'da99_rack_middleware'

def get var, path
  url = "http://localhost:#{ENV['PORT']}#{path}"

  case var
  when :http_code
    `bin/get -w "%{#{var}}" "#{url}"`.strip.to_i
  when :redirect_url
    `bin/get -w "%{#{var}}" "#{url}"`.strip
  when :redirect
    raw = `bin/get -w '%{http_code} %{redirect_url}' "#{url}"`
    pieces = raw.strip.split
    pieces[0] = pieces[0].to_i
    pieces
  when :output
    `bin/get                "#{url}"`
  else
    fail "Unknown option: #{var.inspect}"
  end
end # === def get
