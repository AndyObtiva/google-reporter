# frozen_string_literal: true

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end
require 'glimmer/launcher'
require 'rake'
require 'juwelier'

Juwelier::Tasks.new do |gem|
  # see http://guides.rubygems.org/specification-reference/ for more options
  gem.name        = 'google_reporter'
  gem.homepage    = 'https://github.com/ariel-codes/google_reporter'
  gem.summary     = %(Google Reporter)
  gem.description = %(Coletor de informações de pesquisa)
  gem.email       = 'ariel.santos@dcc.ufmg.br'
  gem.author      = 'Ariel Santos'

  gem.files         = Dir['VERSION', 'LICENSE.txt', 'app/**/*', 'bin/**/*', 'config/**/*', 'db/**/*', 'docs/**/*',
                          'fonts/**/*', 'icons/**/*', 'images/**/*', 'lib/**/*', 'package/**/*', 'script/**/*', 'sounds/**/*', 'vendor/**/*', 'videos/**/*']
  gem.require_paths = %w[vendor lib app]
  gem.executables   = ['google_reporter']
  # dependencies defined in Gemfile
end
Juwelier::RubygemsDotOrgTasks.new

require 'glimmer/rake_task'
Glimmer::RakeTask::Package.javapackager_extra_args =
  " -name 'Google Reporter'" \
  " -title 'Google Reporter'" \
  " -Bmac.CFBundleName='Google Reporter'" \
  " -Bmac.CFBundleIdentifier='org.googlereporter.application.Googlereporter'"
# " -BlicenseType=" +
# " -Bmac.category=" +
# " -Bmac.signing-key-developer-id-app="
