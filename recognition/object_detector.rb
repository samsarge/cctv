# frozen_string_literal: true

module Recognition
  class ObjectDetector
    def initialize(dataset = 'datasets/haarcascade_frontalface_alt.xml.gz')
      @classifier = OpenCV::CvHaarClassifierCascade.load(dataset)
      @objects_detected = 0
      @frames_objects_detected_for = 0
      @frames = []
    end

    attr_reader :frames_objects_detected_for, :objects_detected

    attr_accessor :frames

    def call(img)
      cv_seq = @classifier.detect_objects(img) do |rect|
        @frames_objects_detected_for += 1
        draw_rectangle_around_recognised_objects(image: img, rect: rect)
      end
      @objects_detected = cv_seq.length
      self
    end

    def lock_pc?
      frame_count = Recognition::Constants::AMOUNT_OF_FRAMES_BEFORE_LOCK
      @frames.last(frame_count) == Array.new(frame_count, false)
    end

    def objects_detected?
      return true if @objects_detected > 0
      @frames_objects_detected_for = 0
      false
    end

    def objected_detected_for_frame_threshold?
      return false unless objects_detected?
      (@frames_objects_detected_for % Recognition::Constants::FRAME_THRESHOLD) == 0
    end

    private

    def draw_rectangle_around_recognised_objects(image:, rect:)
      image.rectangle!(rect.top_left, rect.bottom_right, color: OpenCV::CvColor::Red)
    end
  end
end
