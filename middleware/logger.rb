# frozen_string_literal: true

require 'logger'

class SimplerLogger
  def initialize(app, **options)
    @log = Logger.new(options[:logdev] || $stdout)
    @app = app
  end

  def call(env)
    @status, @header, @body = @app.call(env)
    request = Rack::Request.new(env)
    response = Rack::Response.new(@body, @status, @header)
    @log.info("Request: #{request_msg(env)}")
    @log.info("Handler: #{handler(env)}")
    @log.info("Parameters: #{request.params}")
    @log.info("Response: #{response_msg(env)}")
    response.finish
  end

  def request_msg(env)
    "#{env['REQUEST_METHOD']} #{env['REQUEST_URI']}"
  end

  def handler(env)
    "#{controller_name(env)}##{env['simpler.action']}"
  end

  def controller_name(env)
    env['simpler.controller'].class.name.match('(?<name>.+Controller)')[:name] if env['simpler.controller']
  end

  def response_msg(env)
    template = "Response: #{@status} #{status_msg} [#{@header['content-type']}]"
    view_template = env['simpler.view_template']
    return template unless view_template

    "#{template} #{view_template}"
  end

  def status_msg
    Rack::Utils::HTTP_STATUS_CODES[@status]
  end
end
