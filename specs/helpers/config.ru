
require 'cuba'
require 'da99_rack_protect'

Cuba.use Da99_Rack_Protect do |mid|
  mid.config :host, :localhost, 'da99_sample.com'
end

if ENV['IS_DEV']
  Cuba.use Rack::ShowExceptions
end

Cuba.define do

  on get do
    on(root) { res.write "Root" }
    on('hello') { res.write 'Hello' }
    on('hello/s') { res.write 'Hello/' }
  end

end

run Cuba
