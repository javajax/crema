# Crema

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'crema'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install crema

## Usage


```ruby
    class Crema::CookieController < Crema::Controller
      class << self
        attr_accessor :session
      end

      def filter(env)
        env[:authentication] == :session
      end

      def callbefore(request_env)
        unless self.class.session.nil?
          request_env[:request_headers]["Cookie"] = self.class.session
        end
        request_env
      end

      def callback(response_env)
        if response_env.response_headers["set-cookie"]
          self.class.session = response_env.response_headers["set-cookie"]
        end
        response_env
      end
    end
```