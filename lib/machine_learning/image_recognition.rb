require 'net/http'
require 'uri'
require 'json'
require 'base64'

module MachineLearning
  class NaturalLanguage

    API_KEY = Rails.application.credentials.google_api_key

    def initialize
    end

    def text_detection(image)
      uri = URI.parse("https://language.googleapis.com/v1beta1/documents:analyzeSentiment?key=#{API_KEY}")
      request = Net::HTTP::Post.new(uri)
      
      request.content_type = "application/json"
      request.body = ""

      param        = {
        "requests" =>
        [
          {
            "image" =>
            {
              "content" => Base64.strict_encode64(open(image).read)
            },
            "features" =>
            [
              {
                "type"       => "TEXT_DETECTION"
              },
            ]
          }
        ]
      }

      request.body = param.to_json
      req_options = {
        use_ssl: uri.scheme == "https",
      }

      begin 
        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end
        json = JSON.parse(response.body)
        result = json["responses"][0]["fullTextAnnotation"]["text"]
      
      rescue StandardError => e
        puts e.message
        result = nil
      end
      result
    end

  end
end
