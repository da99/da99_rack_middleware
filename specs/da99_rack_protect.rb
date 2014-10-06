
RACK_PROTECTS_DIR = File.join File.dirname(`gem which rack-protection`.strip), '/rack/protection'
RACK_PROTECTS = Dir.glob(RACK_PROTECTS_DIR + '/*').map { |f|
  File.basename(f).sub('.rb', '') 
}.sort


describe Da99_Rack_Protect do

  it "runs" do
    get(:http_code, '/').should == 200
  end

  it "does not have duplicates in Ignore_Rack_Protects, Known_Rack_Protects" do
    (Da99_Rack_Protect::Ignore_Rack_Protects & Da99_Rack_Protect::Known_Rack_Protects).
      should.be.empty
  end

  it "sets X-Frame-Options header to: SAMEORIGIN" do
    get(:x_frame_options, '/').should == 'SAMEORIGIN'
  end

  it "returns 400 if browser is MSIE 6" do
    get(:http_code, '/', '--header "User-Agent: Mozilla/5.0 (Windows; U; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)"').
      should == 400
  end

  it "returns 400 if browser is MSIE 7" do
    get(:http_code, '/', '--header "User-Agent: Mozilla/4.0(compatible; MSIE 7.0b; Windows NT 6.0)"').
      should == 400
  end

  it "returns 400 if browser is MSIE 8" do
    get(:http_code, '/', '--header "User-Agent: Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0; GTB7.4; InfoPath.2; SV1; .NET CLR 3.3.69573; WOW64; en-US)"').
      should == 400
  end

  describe 'unknown rack protect' do

    before { @random_file = RACK_PROTECTS_DIR + '/random_rack_file.rb' }

    after { `rm -f #{@random_file}` }

    it "fails if unknown rack-protection middleware is found" do
      `touch #{@random_file}`
      `ruby -e "require 'da99_rack_protect'" 2>&1`.
        should.match /Unknown rack-protection middleware: ..random_rack_file.. \(/
    end

  end # === describe

end # === describe da99_rack_protect ===

describe Da99_Rack_Protect::Allow_Only_Roman_Uri do

  it "returns 400 if uri has non-roman chars" do
    get(:http_code, '/()').should == 400
  end

  it "returns 400 if query string has invalid chars: @+" do
    get(:http_code, '/?@+').should == 400
  end

  it "output 'Invalid chars' in content" do
    get(:output, '/()').should.match /Invalid chars/
  end

  it "allows special chars in query string: /?module=allow%20(event)&testNum=48" do
    get(:http_code, '/?module=allow%20(event)').should == 200
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



