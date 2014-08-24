
def get var, path
  `bin/get -w "%{#{var}}" "http://localhost:#{ENV['PORT']}#{path}"`.strip
end

describe "da99_rack_middleware" do

  it "runs" do
    get(:http_code, '/hello').to_i.should == 301
  end

end # === describe da99_rack_middleware ===
