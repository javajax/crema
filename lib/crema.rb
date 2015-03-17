require "faraday"
require "json"
require "ostruct"
require "dotenv"
require "pry"

Dotenv.load

require "crema/version"
require "crema/controllers/base"

module Crema
  def self.config
    @config ||= Configuration.new
  end

  def self.configure
    yield(config)
  end

  def self.client
    @client ||= Faraday.new(url: config.url) do |conn|
      conn.response :logger
      conn.adapter  Faraday.default_adapter
      config.controllers.each do |controller|
        conn.builder.insert(0, controller)
      end
    end
  end

  # get_customer(123)
  def self.method_missing(message, *args)
    verb, path = message.to_s.split("_")
    response = client.public_send(verb, path)
    response.env.response
  end

  def self.add_controller(klass)
    unless klass
      fail unless block_given?
      klass = Class.new(Crema::Controller)
      yield(klass)
    end
    self.config.controllers << klass
  end
end
