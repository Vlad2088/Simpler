# frozen_string_literal: true

require 'yaml'
require 'singleton'
require 'sequel'
require_relative 'router'
require_relative 'controller'

module Simpler
  class Application
    include Singleton

    attr_reader :db

    def initialize
      @router = Router.new
      @db = nil
    end

    def bootstrap!
      setup_database
      require_app
      require_routes
    end

    def call(env)
      route = @router.route_for(env)
      return not_found unless route

      setroute_params(env, route)
      controller = route.controller.new(env)
      action = route.action

      make_responce(controller, action)
    end

    def routes(&block)
      @router.instance_eval(&block)
    end

    private

    def setroute_params(env, route)
      route.add_params(env['PATH_INFO'])
      env['simpler.route_params'] = route.params
    end

    def not_found
      Rack::Response.new(['Not found'], 404).finish
    end

    def require_app
      Dir["#{Simpler.root}/app/**/*.rb"].sort.each { |file| require file }
    end

    def require_routes
      require Simpler.root.join('config/routes')
    end

    def make_responce(controller, action)
      controller.make_responce(action)
    end

    def setup_database
      database_config = YAML.load_file(Simpler.root.join('config/database.yml'))
      database_config['database'] = Simpler.root.join(database_config['database'])

      @db = Sequel.connect(database_config)
    end
  end
end
