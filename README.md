# Recognition camera script

Capture recognised objects via webcam

# Setup
  - brew install opencv@2
  - bundle, if you get errors run
  - gem install ruby-opencv -- --with-opencv-dir=/usr/local/opt/opencv@2
  - ruby app.rb

# Notes
This depends greatly on your ruby version.
If you get cpp errors when installing the gem then use a lower ruby version. I can confirm it doesn't work on 2.6.x
