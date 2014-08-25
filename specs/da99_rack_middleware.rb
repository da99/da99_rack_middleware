
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

describe Da99_Rack_Middleware::Squeeze_Uri_Dots do

  it "squeezes multiple dots into one" do
    code, url = get(:redirect, '/hello.....rb')
    code.should == 301
    url.should.match /\/hello\.rb/
  end

  it "replaces .../ with /" do
    code, url = get(:redirect, '/hello.../abc')
    code.should == 301
    url.should.match /\/hello\/abc/
  end

  it "replaces /... with /" do
    code, url = get(:redirect, '/hello/...h')
    code.should == 301
    url.should.match /\/hello\/h/
  end

end # === describe Squeeze_Uri_Dots

describe Da99_Rack_Middleware::No_Slash_Path_Ending do

  it "redirects to path with no ending slash" do
    code, url = get(:redirect, '/slash/')
    code.should == 301
    url.should.match /\/slash$/
  end

end # === describe No_Slash_Path_Ending

describe Da99_Rack_Middleware::Root_Favicon_If_Not_Found do

  it "redirects to /favicon.ico if deeper ico file not found." do
    code, url = get(:redirect, '/something/favicon.ico')
    code.should == 302
    url.should.match /\:4567\/favicon.ico/
  end

end # === describe Root_Favicon_If_Not_Found
