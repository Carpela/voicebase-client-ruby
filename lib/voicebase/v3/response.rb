module VoiceBase
  module V3
    module Response

      TRANSCRIPT_READY_STATUS = "finished".freeze

      def success?

        # for the V1 API this indicates both a successful HTTP status code and a values of "SUCCESS" in the
        # returned JSON. with V2, there is no "SUCCESS" value. The combined use was split, adding
        # #transcript_ready? to both interfaces.

        ok? && parsed_response['status'].to_i < 400
      end

      def media_id
        parsed_response['mediaId'] || parsed_response['media']['mediaId']
      end
      end

      def transcript_ready?
        parsed_response['media']['status'].casecmp(TRANSCRIPT_READY_STATUS) == 0
      end

      def transcript
        if headers["content-type"].to_s.match(/text\/srt/) ||
          headers["content-type"].to_s.match(/text\/plain/)
          parsed_response
        else
          # json
          if parsed_response['media']
            parsed_response['media']['transcripts']['latest']['words']
          else
            parsed_response['transcripts']['latest']['words']
          end
        end


        # this retrieves the JSON transcript only
        # the plain text transcript is a plain text non-JSON response
        #voicebase_response['media']['transcripts']['latest']['words']
      end
      
      def keywords
        parsed_response['media']['keywords']['latest']['words']
      end
      
      def keyword_groups
        parsed_response['media']['keywords']['latest']['groups']
      end
      
      def topics
        parsed_response['media']['topics']['latest']['topics']
      end

      # private

      # def voicebase_response
      #   http_response.parsed_response
      # end

    end
  end
end
