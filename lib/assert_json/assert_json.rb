# nodoc
module AssertJson
  def assert_json(json_string)
    return unless block_given?

    @json = AssertJson::Json.new(json_string)
    # json.instance_exec(json, &block)
    yield @json
    @json.test_for_unexpected_keys('root')
  end

  def has_length_of(expected)
    @json.has_length_of(expected)
  end

  def item(index, &block)
    @json.item(index, &block)
  end

  def has(*args, &block)
    @json.has(*args, &block)
  end

  def not?(*args, &block)
    @json.has_not(*args, &block)
  end
  alias_method :has_not, :not?

  def only?
    @json.has_only
  end
  alias_method :has_only, :only?

  # nodoc
  class Json
    def initialize(json_string)
      @decoded_json = ActiveSupport::JSON.decode(json_string)
      @expected_keys = []
      @only = false
    end

    def has_length_of(expected)
      raise_error("element #{@decoded_json.inspect} is not sizable") unless @decoded_json.respond_to?(:size)
      return if @decoded_json.size == expected
      raise_error("element #{@decoded_json.inspect} has #{@decoded_json.size} items, expected #{expected}")
    end

    def item(index)
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

    def element(*args)
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
          gen_error = -> { raise_error("element #{token[arg].inspect} does not match #{second_arg.inspect}") }
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
        raise_error("element #{arg} not found") if !block_given? && token != arg
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

      return unless block_given?
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
    alias_method :has, :element

    def not_element(*args)
      arg = args.shift
      token = @decoded_json
      case token
      when Array
        raise_error("element #{arg} found, but not expected") if token.include?(arg.to_s)
      else
        raise_error("element #{arg} found, but not expected") if token.keys.include?(arg.to_s)
      end
    end
    alias_method :has_not, :not_element

    def only
      @only = true
    end
    alias_method :has_only, :only

    def test_for_unexpected_keys(name = 'root')
      return unless @only
      return unless @decoded_json.is_a?(Hash)

      unexpected_keys = @decoded_json.keys - @expected_keys
      return if unexpected_keys.count <= 0
      raise_error("element #{name} has unexpected keys: #{unexpected_keys.join(', ')}")
    end

    private

    def raise_error(message)
      if Object.const_defined?(:MiniTest)
        fail MiniTest::Assertion, message
      else
        fail Test::Unit::AssertionFailedError, message
      end
    end
  end
end
