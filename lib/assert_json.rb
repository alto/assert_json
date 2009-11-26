module AssertJson
  
  def assert_json(json_string, &block)
    if block_given?
      yield AssertJson::Json.new(json_string)
    end
  end

  class Json
    
    def initialize(json_string)
      @decoded_json = ActiveSupport::JSON.decode(json_string)
    end
    
    def element(*args, &block)
      arg = args.shift
      token = @decoded_json.is_a?(Array) ? @decoded_json.shift : @decoded_json
      case token
      when Hash
        raise Test::Unit::AssertionFailedError.new("element #{arg} not found") unless token.keys.include?(arg)
        if second_arg = args.shift
          raise Test::Unit::AssertionFailedError.new("element #{token[arg].inspect} does not match #{second_arg.inspect}") if second_arg != token[arg]
        end
      when String, Array
        raise Test::Unit::AssertionFailedError.new("element #{arg} not found") if token != arg
      when NilClass
        raise Test::Unit::AssertionFailedError.new("no element left")
      else
        flunk
      end
    
      if block_given?
        begin
          in_scope, @decoded_json = @decoded_json, token.is_a?(Hash) ? token[arg] : token
          yield
        ensure
          @decoded_json = in_scope
        end
      end
      
    end
    
    def not_element(*args, &block)
      arg = args.shift
      token = @decoded_json
      raise Test::Unit::AssertionFailedError.new("element #{arg} found, but not expected") if token.keys.include?(arg)
    end
    
  end
end
