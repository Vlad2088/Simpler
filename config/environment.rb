# frozen_string_literal: true

require 'rack'
require_relative '../middleware/logger'
require_relative '../lib/Simpler'

Simpler.application.bootstrap!
