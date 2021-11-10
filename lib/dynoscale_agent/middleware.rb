# frozen_string_literal: true

require 'dynoscale_agent/request_calculator'
require 'dynoscale_agent/reporter'
require 'dynoscale_agent/recorder'

module DynoscaleAgent
  class Middleware

    MEASUREMENT_TTL = 5 # minutes


    def initialize(app)
      @app = app
    end

    def call(env)
      is_dev = ENV['DYNOSCALE_DEV'] == 'true'
      unless ENV['DYNOSCALE_URL']
        puts "Missing DYNOSCALE_URL environment variable"
        return @app.call(env)
      end 
      return @app.call(env) if ENV['SKIP_DYNASCALE_AGENT']
      return @app.call(env) unless is_dev || ENV['DYNO']&.split(".")&.last == "1"
      
      Recorder.record!(env)
      Reporter.start!(env, Recorder) unless Reporter.running?


      @app.call(env)
    end
  end
end
