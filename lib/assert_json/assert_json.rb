module AssertJson

  def assert_json(json_string, &block)
    if block_given?
      @json = AssertJson::Json.new(json_string)
      # json.instance_exec(json, &block)
      yield @json
      @json.test_for_unexpected_keys('root')
    end
  end

  def item(index, &block)
    @json.item(index, &block)
  end

  def has(*args, &block)
    @json.has(*args, &block)
  end

  def has_not(*args, &block)
    @json.has_not(*args, &block)
  end

  def has_only
    @json.has_only
  end

  class Json

    def initialize(json_string)
      @decoded_json = ActiveSupport::JSON.decode(json_string)
      @expected_keys = []
      @only = false
    end

    def item(index, &block)
      only_in_scope = @only
      expected_keys_in_scope = @expected_keys
      @expected_keys = []
      decoded_json_in_scope = @decoded_json
      @decoded_json = @decoded_json[index]
      begin
        yield if block_given?
        test_for_unexpected_keys(index)
      ensure
        @decoded_json = decoded_json_in_scope
        @expected_keys = expected_keys_in_scope
        @only = only_in_scope
      end
    end

    def element(*args, &block)
      arg = args.shift

      token = case @decoded_json
              when Array
                @decoded_json.shift
              else
                @decoded_json
              end

      case token
      when Hash
        arg = arg.to_s
        raise_error("element #{arg} not found") unless token.keys.include?(arg)
        unless args.empty?
          second_arg = args.shift
          gen_error = lambda {raise_error("element #{token[arg].inspect} does not match #{second_arg.inspect}")}
          case second_arg
          when Regexp
            gen_error.call if second_arg !~ token[arg].to_s
          when Symbol
            gen_error.call if second_arg.to_s != token[arg]
          else
            gen_error.call if second_arg != token[arg]
          end
        end
      when Array
        if !block_given? && token != arg
          raise_error("element #{arg} not found")
        end
      when String
        case arg
        when Regexp
          raise_error("element #{arg.inspect} not found") if token !~ arg
        else
          raise_error("element #{arg.inspect} not found") if token != arg.to_s
        end
      when NilClass
        raise_error("no element left")
      else
        flunk
      end

      @expected_keys.push arg

      if block_given?
        begin
          only_in_scope = @only
          expected_keys_in_scope = @expected_keys
          @expected_keys = []
          decoded_json_in_scope = @decoded_json
          @decoded_json = case token
                          when Hash
                            token[arg]
                          else
                            token
                          end
          yield
          test_for_unexpected_keys(arg)
        ensure
          @expected_keys = expected_keys_in_scope
          @only = only_in_scope
          @decoded_json = decoded_json_in_scope
        end
      end
    end
    alias has element

    def not_element(*args, &block)
      arg = args.shift
      token = @decoded_json
      case token
      when Array
        raise_error("element #{arg} found, but not expected") if token.include?(arg.to_s)
      else
        raise_error("element #{arg} found, but not expected") if token.keys.include?(arg.to_s)
      end
    end
    alias has_not not_element

    def only
      @only = true
    end
    alias has_only only

    def test_for_unexpected_keys(name = 'root')
      return unless @only

      if @decoded_json.is_a?(Hash)
        unexpected_keys = @decoded_json.keys - @expected_keys
        if unexpected_keys.count > 0
          raise_error("element #{name} has unexpected keys: #{unexpected_keys.join(', ')}")
        end
      end
    end

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
