module Api
  class AnalyzeController < ApplicationController

    def text_detect
      ir = MachinLearning::ImageRecognition.new
      res = ir.text_detect(text_detect_params['image'])
      puts res
    end

    private

    def text_detect_params
      params.permit(:image)
    end
  end
end
