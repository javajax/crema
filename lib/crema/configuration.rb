module Crema
  class Configuration
    attr_accessor :url, :controllers

    def initialize
      @url = ENV["CREAMA_URL"]
      @controllers = []
    end
  end
end
