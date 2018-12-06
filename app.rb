require 'opencv'

FPS           = 30.freeze
KEY_WAIT_TIME = (1000 / FPS).freeze
ESCAPE_KEY    = "\e".freeze
webcam        = OpenCV::CvCapture.open
window        = OpenCV::GUI::Window.new 'video'
detector      = OpenCV::CvHaarClassifierCascade.load('haarcascade_frontalface_alt.xml.gz')

SIGNIFICANCE_LEVEL = 6
@time_in_frame = 0

puts 'Starting...'
puts "Significance level: #{SIGNIFICANCE_LEVEL} frames"
puts 'Press ESC or CTRL+C to close'

# if this doesn't reach SIGNIFICANCE_LEVEL then the detection isnt in
# frame long enough for us to care. e.g someone walking past not stopping

Dir.glob('captures/*').each { |picture| File.delete(picture) }

loop do
  capture = webcam.query

  detected_objects = detector.detect_objects(capture) do |rect|
    # detected a face
    # this block returns the amount of objects detected
    capture.rectangle!(rect.top_left, rect.bottom_right, color: OpenCV::CvColor::Red)
    puts 'Face detected'
  end

  if detected_objects.length > 0
    @time_in_frame += 1
    if (@time_in_frame % SIGNIFICANCE_LEVEL == 0)
      month = Time.now.strftime("%B")
      date = Time.now.day
      entry_time = Time.now.strftime("%I:%M:%S_%p")
      file_name_path = "captures/#{month}_#{date}_#{entry_time}.jpg"
      capture.save(file_name_path)
      puts "Captured - saved to: #{file_name_path}"
    end
  else
    @time_in_frame = 0
  end

  window.show capture

  puts "CERTAINTY: #{@time_in_frame}"
  # wait for a pressed key
  key = OpenCV::GUI.wait_key KEY_WAIT_TIME

  break if key&.chr == ESCAPE_KEY
end
