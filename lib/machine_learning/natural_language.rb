require 'net/http'
require 'uri'
require 'json'

module MachineLearning
  class NaturalLanguage

    API_KEY = Rails.application.credentials.google_api_key
    
    def initialize
    end

    def analyze_sentiment(comment)
      uri = URI.parse("https://language.googleapis.com/v1beta1/documents:analyzeSentiment?key=#{API_KEY}")
      request = Net::HTTP::Post.new(uri)
      
      request.content_type = "application/json"
      request.body = ""
      request.body = {"document": {"type": "PLAIN_TEXT", "content": comment}}.to_json

      req_options = {
        use_ssl: uri.scheme == "https",
      }

      begin 
        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          http.request(request)
        end
        json = JSON.parse(response.body)
        score = json['documentSentiment']['score']
        magnitude = json['documentSentiment']['magnitude']

        result  = { 'score': score, 'magnitude': magnitude }
      
      rescue StandardError => e
        puts e.message
        result = nil
      end
      result
    end

  end
end
