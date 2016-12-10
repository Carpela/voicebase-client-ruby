require 'spec_helper'

describe Voicebase::Client do
  context ".camelize_name" do
    it "changes snake_cased_terms to be lowerCamelCasedTerms" do
      expect(Voicebase::Client.camelize_name("i_love_transcripts")).to eq("iLoveTranscripts")
    end
  end

  it "accepts token as parameter" do
    expect(Voicebase::Client.new({token: "foobar"}).token.to_s).to eq("foobar")
  end
end
