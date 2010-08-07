require "spec_helper"

module Curl
  describe Easy, ".new" do
    it "should return a new Curl::Easy object" do
      Easy.new.should be_a(Easy)
    end
  end

  describe Easy do
    before :each do
      @easy = Easy.new
    end

    describe "#dup" do
      it "should return a new Curl::Easy object" do
        @easy.dup.should be_a(Easy)
      end

      it "should have a seperate libCurl handle" do
        @easy.dup.pointer.should_not equal(@easy.pointer)
      end
    end

    describe "#reset" do
      it "should reset all set options" do
        # TODO how would one test that?
        @easy.should respond_to(:reset)
      end
    end

    describe "#setopt" do
      it "should correctly set string options" do
        @easy.setopt(OPTION[:URL], "http://google.de")
      end

      it "should correctly set string options" do
        @easy.setopt(OPTION[:PORT], 123)
      end
    end

    describe "#getinfo" do
      it "should return internal information" do
        @easy.getinfo(INFO[:EFFECTIVE_URL]).should == ""

        @easy.setopt(OPTION[:URL], "http://google.de")
        @easy.getinfo(INFO[:EFFECTIVE_URL]).should == "http://google.de"
      end
    end

    describe "#perform" do
#      it "should perform the request" do
#        @easy.setopt(OPTION[:URL], "http://google.de")
#        @easy.perform
#      end
    end

    describe "#escape" do
      it "should escape the passed string" do
        str = @easy.escape("Hello World!")
        str.should == "Hello%20World%21"
      end
    end

    describe "#unescape" do
      it "should unescape the passed string" do
        str = @easy.unescape("Hello%20World%21")
        str.should == "Hello World!"
      end

      it "should correctly unescape strings containing '%00'" do
        str = @easy.unescape("%00Test")
        str.should == "\00Test"
      end
    end

    describe "#error_string" do
      it "should return a string describing the passed error code" do
        @easy.error_string(:OK).should == "No error"
        @easy.error_string(:UNSUPPORTED_PROTOCOL).should == "Unsupported protocol"
      end
    end
  end
end