# frozen_string_literal: true

require 'opencv'
require './recognition/constants'
require './recognition/object_detector'
require './recognition/cam'
require './recognition/engine'
Recognition::Engine.new.start
