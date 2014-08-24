
describe Da99_Rack_Middleware do

  it "runs" do
    get(:http_code, '/').should == 200
  end

end # === describe da99_rack_middleware ===

describe Da99_Rack_Middleware::Allow_Only_Roman_Uri do

  it "returns 400 if uri has non-roman chars" do
    get(:http_code, '/()').should == 400
  end

  it "output 'Invalid chars' in content" do
    get(:output, '/()').should.match /Invalid chars/
  end

end # === describe Allow_Only_Roman_Uri


