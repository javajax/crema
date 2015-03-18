class Crema::Controller < Faraday::Middleware
  attr_reader :app, :options
  
  def initialize(app, options = {})
    @app = app
    @options = options
  end

  def self.setup(verbs, path)
    verbs(*verbs)
    path(path)
  end
  
  # TODO(jack) assign name in gsub ie. (<attr>)
  def self.path(_path=nil)
    # TODO(jack) think about operator overloading
    return @path if _path.nil?
    _path.gsub!(/(:\w+)/, "([a-z|A-Z|0-9]+)")
    _path << "$"
    @path ||= Regexp.new _path
  end

  def self.verbs(*_verb)
    # TODO(jack) think about operator overloading
    return @verbs if _verb.nil?
    @verbs ||= begin
                 new_verbs = Array(_verb)

                 new_verbs.each do |verb|
                   unless respond_to?(verb)
                     define_method(verb) do |x = {}|
                       response = Hash.new
                       response[:body] = x[:body]               if x[:body]
                       response[:request_headers] = x[:headers] if x[:headers]
                       response[:query] = x[:query]             if x[:query]
                       response
                     end
                   end

                   define_method("#{verb}_callbefore"){|x| x} unless respond_to?(verb)
                   define_method("#{verb}_callback"){|x| x}   unless respond_to?(verb)
                 end
                 
                 new_verbs
               end
  end

  def verbs
    self.class.verbs
  end

  def path
    self.class.path
  end
  
  def callbefore(request_env)
    request_env
  end

  def callback(response_env)
    response_env
  end

  def master_callbefore(request_env)
    # conditional for controllers that perform on all methods
    if respond_to?(request_env[:method])
      verb_hash = public_send(request_env[:method])
      request_env[:url].query = verb_hash[:query] if verb_hash[:query]
      request_env[:body].merge!(verb_hash[:body]) if verb_hash[:body]
      request_env[:request_headers].merge!(verb_hash[:request_headers]) if verb_hash[:request_headers]

      request_env = public_send("#{request_env[:method]}_callbefore", request_env)

    end

    public_send(:callbefore, request_env)
  end

  def master_callback(response_env)
    # conditional for controllers that perform on all methods
    if respond_to?("#{response_env[:method]}_callback")
      response_env = public_send("#{response_env[:method]}_callback", response_env)
    end

    response_object = deserialize(response_env[:body])
    response_env[:response] = response_object unless response_object.nil?

    callback(response_env)
  end

  # TODO(jack) more gacfully handle other response types i.e. 3xx
  def deserialize(body)
    begin
      JSON.parse(body)
    rescue
      nil
    end
  end

  def filter(env)
    # TODO(jack) make this less ugly
    # check to see if the controller matchs the verbs and path
    ((path =~ env[:url].path) && verbs.include?(env[:method]))
  end

  def call(env)
    return @app.call(env) unless filter(env)
    
    lambda(&method(:master_callbefore)).call(env)
    @app.call(env).on_complete( &method(:master_callback) )
  end
end
