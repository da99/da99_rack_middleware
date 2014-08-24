
require 'Bacon_Colored'
require 'pry'
require 'da99_rack_middleware'

def get var, path
  url = "http://localhost:#{ENV['PORT']}#{path}"

  case var
  when :http_code
    `bin/get -w "%{#{var}}" "#{url}"`.strip.to_i
  when :output
    `bin/get                "#{url}"`
  else
    fail "Unknown option: #{var.inspect}"
  end
end # === def get
