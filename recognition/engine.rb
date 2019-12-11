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


        @detector.frames << @detector.objects_detected?

        if @detector.objects_detected? && @detector.objected_detected_for_frame_threshold?
          puts "DETECTION LOCK ON"
          save_image_to_captures(image)
          @detection_lock = true
        else
          return lock! if lock_pc?
        end

        @window.show image
        puts "Frames object visible: #{@detector.frames_objects_detected_for}"
        key = OpenCV::GUI.wait_key Recognition::Constants::KEY_WAIT_TIME
        break if key&.chr == Recognition::Constants::ESCAPE_KEY
      end
    end

    private

    def lock!
      puts 'LOCKING'
      Kernel.exec('/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend')
      exit 1
    end

    def lock_pc?
      !@detector.objects_detected? && @detection_lock && @detector.lock_pc?
    end

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
