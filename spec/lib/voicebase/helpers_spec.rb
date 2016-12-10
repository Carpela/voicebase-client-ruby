require 'spec_helper'

class Voicebase::TestClass
  include Voicebase::Helpers
end

describe Voicebase::Helpers do

  context "class" do
    it "should camelize name" do
      expect(Voicebase::TestClass.camelize_name("request_status")).to eq("requestStatus")
    end
  end

  it "should camelize name" do
    expect(Voicebase::TestClass.new.camelize_name("request_status")).to eq("requestStatus")
  end

end