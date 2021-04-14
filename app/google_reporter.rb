$LOAD_PATH.unshift(File.expand_path('..', __FILE__))

require 'bundler/setup'
Bundler.require(:default)
require 'google_reporter/view/app_view'

class GoogleReporter
  include Glimmer

  APP_ROOT = File.expand_path('../..', __FILE__)
  VERSION = File.read(File.join(APP_ROOT, 'VERSION'))
  LICENSE = File.read(File.join(APP_ROOT, 'LICENSE.txt'))
end
