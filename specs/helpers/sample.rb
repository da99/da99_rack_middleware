
require 'cuba'
require 'da99_rack_middleware'

Cuba.use Da99_Rack_Middleware

Cuba.define do

  on get do
    on(root) { res.write "Root" }
    on('hello') { res.write 'Hello' }
    on('hello/s') { res.write 'Hello/' }
  end

end
