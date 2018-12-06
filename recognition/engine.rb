# frozen_string_literal: true

module Recognition
  class Engine
    def initialize
      @window   = OpenCV::GUI::Window.new 'video'
      @webcam   = Recognition::Cam.new
      @detector = Recognition::ObjectDetector.new
    end

    def start
      init_captures_folder

      loop do
        image = @webcam.take_photo
        @detector.call(image)
        if @detector.objects_detected? && @detector.objected_detected_for_frame_threshold?
          save_image_to_captures(image)
        end

        @window.show image
        puts "Frames object visible: #{@detector.frames_objects_detected_for}"
        key = OpenCV::GUI.wait_key Recognition::Constants::KEY_WAIT_TIME
        break if key&.chr == Recognition::Constants::ESCAPE_KEY
      end
    end

    private

    def notify_startup
      puts 'Starting...'
      puts "Significance level: #{Recognition::Constants::FRAME_THRESHOLD} frames"
      puts 'Press ESC or CTRL+C to close'
    end

    def save_image_to_captures(image)
      month          = Time.now.strftime("%B")
      date           = Time.now.day
      entry_time     = Time.now.strftime("%I:%M:%S_%p")
      file_name_path = "captures/#{month}_#{date}_#{entry_time}.jpg"
      puts "Captured - saved to: #{file_name_path}"
      image.save(file_name_path)
    end

    def init_captures_folder
      return Dir.mkdir('captures') unless Dir['captures'].any?
      Dir.glob('captures/*').each { |picture| File.delete(picture) }
    end
  end
end
