
require 'cuba'
require 'da99_rack_middleware'

Cuba.use Da99_Rack_Middleware.config { |c|
  c.config :host, [:localhost, 'da99_sample.com']
}

Cuba.use Rack::ShowExceptions

Cuba.define do

  on get do
    on(root) { res.write "Root" }
    on('hello') { res.write 'Hello' }
    on('hello/s') { res.write 'Hello/' }
  end

end

run Cuba
