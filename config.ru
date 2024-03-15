# frozen_string_literal: true

require_relative 'config/environment'

use Rack::ContentType, 'text/plain'
use SimplerLogger, logdev: File.expand_path('log/app.log', __dir__)
run Simpler.application
