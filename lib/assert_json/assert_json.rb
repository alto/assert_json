module AssertJson
  
  def assert_json(json_string, &block)
    if block_given?
      json = AssertJson::Json.new(json_string)
      json.instance_exec(json, &block)
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
        raise_error("element #{arg} not found") unless token.keys.include?(arg)
        if second_arg = args.shift
          case second_arg
          when Regexp
            raise_error("element #{token[arg].inspect} does not match #{second_arg.inspect}") if second_arg !~ token[arg]
          else
            raise_error("element #{token[arg].inspect} does not match #{second_arg.inspect}") if second_arg != token[arg]
          end
        end
      when Array
        raise_error("element #{arg} not found") if token != arg
      when String
        case arg
        when Regexp
          raise_error("element #{arg.inspect} not found") if token !~ arg
        else
          raise_error("element #{arg.inspect} not found") if token != arg
        end
      when NilClass
        raise_error("no element left")
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
    alias has element
    
    def not_element(*args, &block)
      arg = args.shift
      token = @decoded_json
      case token
      when Array
        raise_error("element #{arg} found, but not expected") if token.include?(arg)
      else
        raise_error("element #{arg} found, but not expected") if token.keys.include?(arg)
      end
    end
    alias has_not not_element
    
    private
    
      def raise_error(message)
        if Object.const_defined?(:MiniTest)
          raise MiniTest::Assertion.new(message)
        else
          raise Test::Unit::AssertionFailedError.new(message)
        end
      end
    
  end
end
