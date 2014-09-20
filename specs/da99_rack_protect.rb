
describe Da99_Rack_Protect do

  it "runs" do
    get(:http_code, '/').should == 200
  end

end # === describe da99_rack_protect ===

describe Da99_Rack_Protect::Allow_Only_Roman_Uri do

  it "returns 400 if uri has non-roman chars" do
    get(:http_code, '/()').should == 400
  end

  it "output 'Invalid chars' in content" do
    get(:output, '/()').should.match /Invalid chars/
  end

end # === describe Allow_Only_Roman_Uri

describe Da99_Rack_Protect::Squeeze_Uri_Dots do

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

describe Da99_Rack_Protect::No_Slash_Path_Ending do

  it "redirects to path with no ending slash" do
    code, url = get(:redirect, '/slash/')
    code.should == 301
    url.should.match /\/slash\z/
  end

end # === describe No_Slash_Path_Ending

describe Da99_Rack_Protect::Root_Favicon_If_Not_Found do

  it "redirects to /favicon.ico if deeper ico file not found." do
    code, url = get(:redirect, '/something/favicon.ico')
    code.should == 302
    url.should.match /\:4567\/favicon.ico/
  end

  it "does not redirect /favicon.ico" do
    get(:http_code, '/favicon.ico').should == 404
  end

end # === describe Root_Favicon_If_Not_Found

describe Da99_Rack_Protect::Ensure_Host do

  it "returns a 444 error if host does not match allowed hosts" do
    get(:http_code, '/', '--header "Host: MEGA"').should == 444
  end

end # === describe Da99_Rack_Protect::Ensure_Host ===



