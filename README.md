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
    class ApiController < Crema::Controller
      def filter(env)
        env[:authentication] == :api
      end

      def callbefore(request_env)
        request_env[:request_headers]["Content-Type"] = "application/json"
        request_env[:request_headers]["API_KEY"] = ENV["APPLICATION_API_KEY"]
        request_env
      end
    end
```