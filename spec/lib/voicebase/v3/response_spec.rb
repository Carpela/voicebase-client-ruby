require 'spec_helper'

describe VoiceBase::V3::Response do
  let(:v3_api) { '3.0' }

  context "methods dependent on returned HTTP response" do
    context "#success?" do
      let(:http_response_success) { double("http response", code: 200, parsed_response: {}) }
      let(:http_response_error) { double("http response", code: 404) }
      let(:http_response_success_bad_status) { double("http response", code: 200, parsed_response: {"status"=>403}) }
      let(:http_response_success_good_status) { double("http response", code: 200, parsed_response: {"status"=>"finished"}) }

      it "is true in the case of a successful response" do
        response = VoiceBase::Response.new(http_response_success, v3_api)
        expect(response.success?).to be_truthy
      end

      it "is true in the case of a successful response and good status" do
        response = VoiceBase::Response.new(http_response_success_good_status, v3_api)
        expect(response.success?).to be_truthy
      end

      it "is false in the case of an error" do
        response = VoiceBase::Response.new(http_response_error, v3_api)
        expect(response.success?).to be_falsey
      end

      it "is false in the case of bad status code" do
        response = VoiceBase::Response.new(http_response_success_bad_status, v3_api)
        expect(response.success?).to be_falsey
      end

    end
  end

  context "methods based on returned JSON response" do
    context "#media_id" do
      let(:expected_media_id) { '123' }
      let(:parsed_response) { {'mediaId' => expected_media_id} }
      let(:http_response) { double("http response", code: 200, parsed_response: parsed_response) }

      it "returns the media ID from the parsed JSON response" do
        response = VoiceBase::Response.new(http_response, v3_api)
        expect(response.media_id).to eq(expected_media_id)
      end
    end

    context "#transcript_ready?" do
      let(:parsed_response_ready) { {'media' => { 'status' => 'finished'}} }
      let(:parsed_response_not_ready) { {'media' => { 'status' => 'started'}} }
      let(:http_response_ready) { double("http response", code: 200, parsed_response: parsed_response_ready) }
      let(:http_response_not_ready) { double("http response", code: 200, parsed_response: parsed_response_not_ready) }

      it "is true when the transcript is ready" do
        response = VoiceBase::Response.new(http_response_ready, v3_api)
        expect(response.transcript_ready?).to be_truthy
      end

      it "is false when the transcript is not ready" do
        response = VoiceBase::Response.new(http_response_not_ready, v3_api)
        expect(response.transcript_ready?).to be_falsey
      end
    end

    context "#transcript" do
      let(:transcipt) { 'transcript' }
      let(:parsed_response) { { 'media' => { 'transcripts' => { 'latest' => { 'words' => transcipt }}}}}
      let(:headers) { {} }
      let(:http_response) { double("http response", code: 200, parsed_response: parsed_response, headers: headers) }

      context "format json" do
        it "gets the transcript" do
          response = VoiceBase::Response.new(http_response, v3_api)
          expect(response.transcript).to eq(transcipt)
        end
      end

      context "format text" do
        let(:headers) { {"content-type" => "text/plain"} }
        let(:parsed_response) { transcipt }

        it "gets the transcript" do
          response = VoiceBase::Response.new(http_response, v3_api)
          expect(response.transcript).to eq(transcipt)
        end
      end

      context "format srt" do
        let(:headers) { {"content-type" => "text/srt"} }
        let(:parsed_response) { transcipt }

        it "gets the transcript" do
          response = VoiceBase::Response.new(http_response, v3_api)
          expect(response.transcript).to eq(transcipt)
        end
      end
    end

    context "#keywords" do
      let(:keywords) { 'keywords' }
      let(:parsed_response) { { 'media' => { 'keywords' => { 'latest' => { 'words' => keywords }}}}}
      let(:http_response) { double("http response", code: 200, parsed_response: parsed_response) }

      it "gets the keywords" do
        response = VoiceBase::Response.new(http_response, v3_api)
        expect(response.keywords).to eq(keywords)
      end
    end

    context "#keyword_groups" do
      let(:keyword_groups) { 'groups' }
      let(:parsed_response) { { 'media' => { 'keywords' => { 'latest' => { 'groups' => keyword_groups }}}}}
      let(:http_response) { double("http response", code: 200, parsed_response: parsed_response) }

      it "gets the keywords" do
        response = VoiceBase::Response.new(http_response, v3_api)
        expect(response.keyword_groups).to eq(keyword_groups)
      end
    end

    context "#topics" do
      let(:topics) { 'topics' }
      let(:parsed_response) { { 'media' => { 'topics' => { 'latest' => { 'topics' => topics }}}}}
      let(:http_response) { double("http response", code: 200, parsed_response: parsed_response) }

      it "gets the transcript" do
        response = VoiceBase::Response.new(http_response, v3_api)
        expect(response.topics).to eq(topics)
      end
    end
  end
end
