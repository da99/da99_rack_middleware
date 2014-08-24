
def get var, path
  result = `bin/get -w "%{#{var}}" "http://localhost:#{ENV['PORT']}#{path}"`.strip
  case var
  when :http_code
    result.to_i
  else
    result
  end
end

describe "da99_rack_middleware" do

  it "runs" do
    get(:http_code, '/').should == 200
  end

end # === describe da99_rack_middleware ===
