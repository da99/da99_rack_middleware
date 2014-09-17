
require 'Bacon_Colored'
require 'pry'
require 'da99_rack_middleware'

def get var, path, append = ''
  url = "http://localhost:#{ENV['PORT']}#{path}"

  case var

  when :http_code
    `bin/get -w "%{#{var}}" "#{url}" #{append}`.strip.to_i

  when :redirect_url
    `bin/get -w "%{#{var}}" "#{url}" #{append}`.strip

  when :redirect
    raw       = `bin/get -w '%{http_code} %{redirect_url}' "#{url}" #{append}`
    pieces    = raw.strip.split
    pieces[0] = pieces[0].to_i
    pieces

  when :output
    `bin/get  "#{url}"  #{append}`

  else
    fail "Unknown option: #{var.inspect}"

  end # === case var
end # === def get
