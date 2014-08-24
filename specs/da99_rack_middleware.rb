
describe "da99_rack_middleware" do

  it "runs" do
    get(:http_code, '/').should == 200
  end

end # === describe da99_rack_middleware ===

describe Allow_Only_Roman_Uri do

  it "returns 404 if uri has non-roman chars" do
    get(:http_code, '/**').should == 404
  end

  it "output 'Invalid chars' in content" do
    get(:output, '/**')['Invalid chars'].should == 'Invalid chars'
  end

end # === describe Allow_Only_Roman_Uri
