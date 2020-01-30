module Api
  class AnalyzeController < ApplicationController

    def text_detect
      ir = MachineLearning::ImageRecognition.new
      text = ir.text_detection(text_detect_params['image_base64'].split(',')[1])
      res = {}
      if text
        res['text'] = text
      else
        res["message"] = "error"
      end

      render json: res.to_json
    end

    private

    def text_detect_params
      params.require(:analyze).permit(:image_base64)
    end
  end
end
