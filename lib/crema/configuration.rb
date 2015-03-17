module Crema
  class Configuration < OpenStruct
    attr_accessor :url, :controllers

    # can add api_keys
    def initialize
      @url = ENV["CREAMA_URL"]
      @controllers = []
    end
  end
end
