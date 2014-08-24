
def get var, path
  `bin/get -w "%{#{var}}" "http://localhost:#{ENV['PORT']}#{path}"`.strip
end

describe "da99_rack_middleware" do

  it "runs" do
    get(:http_code, '/hello').should == 301
    Da99_Rack_Middleware.should.flunk "No tests written."
  end

end # === describe da99_rack_middleware ===
