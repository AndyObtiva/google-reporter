$LOAD_PATH.unshift(File.expand_path(__dir__))

require 'bundler/setup'
Bundler.require(:default)
require 'view/app'

class GoogleReporter
  include Glimmer

  APP_ROOT = File.expand_path('..', __dir__)
  VERSION  = File.read(File.join(APP_ROOT, 'VERSION'))
  LICENSE  = File.read(File.join(APP_ROOT, 'LICENSE.txt'))
end

GoogleReporter::AppView.launch
