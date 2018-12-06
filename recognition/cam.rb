# frozen_string_literal: true

module Recognition
  class Cam
    def initialize
      @open_cv_capture = OpenCV::CvCapture.open
    end

    def take_photo
      @open_cv_capture.query
    end
  end
end
