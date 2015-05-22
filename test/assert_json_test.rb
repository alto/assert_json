require 'test_helper'

# nodoc
class AssertJsonTest < Minitest::Test
  include AssertJson

  context "strings" do
    should "test_string" do
      assert_json '"key"' do |json|
        json.element 'key'
      end
    end

    should "test_string_crosscheck" do
      assert_raises(MiniTest::Assertion) do
        assert_json '"key"' do |json|
          json.element 'wrong_key'
        end
      end
    end

    should "test_regular_expression_for_strings" do
      assert_json '"string"' do |json|
        json.element(/tri/)
      end
    end

    should "test_regular_expression_for_hash_values" do
      assert_json '{"key":"value"}' do |json|
        json.element 'key', /alu/
      end
    end
  end

  context "hashes" do
    should "test_single_hash" do
      assert_json '{"key":"value"}' do |json|
        json.element 'key', 'value'
      end
    end

    should "test_single_hash_crosscheck_for_key" do
      assert_raises(MiniTest::Assertion) do
        assert_json '{"key":"value"}' do |json|
          json.element 'wrong_key', 'value'
        end
      end
    end

    should "test_single_hash_crosscheck_for_value" do
      assert_raises(MiniTest::Assertion) do
        assert_json '{"key":"value"}' do |json|
          json.element 'key', 'wrong_value'
        end
      end
    end

    should "test_not_element" do
      assert_json '{"key":"value"}' do |json|
        json.element 'key', 'value'
        json.not_element 'key_not_included'
      end
    end

    should "test_not_element_crosscheck" do
      assert_raises(MiniTest::Assertion) do
        assert_json '{"key":"value"}' do |json|
          json.not_element 'key'
        end
      end
    end
  end

  context "arrays" do
    should "test_array" do
      assert_json '["value1","value2","value3"]' do |json|
        json.element 'value1'
        json.element 'value2'
        json.element 'value3'
      end
    end
    should "test_not_element_array" do
      assert_json '["value1","value2"]' do |json|
        json.element 'value1'
        json.element 'value2'
        json.not_element 'value3'
      end
    end
    should "test_array_crosscheck_order" do
      assert_raises(MiniTest::Assertion) do
        assert_json '["value1","value2","value3"]' do |json|
          json.element 'value2'
        end
      end
    end
    should "test_array_crosscheck_for_first_item" do
      assert_raises(MiniTest::Assertion) do
        assert_json '["value1","value2","value3"]' do |json|
          json.element 'wrong_value1'
        end
      end
    end
    should "test_array_crosscheck_for_second_item" do
      assert_raises(MiniTest::Assertion) do
        assert_json '["value1","value2","value3"]' do |json|
          json.element 'value1'
          json.element 'wrong_value2'
        end
      end
    end

    should "test_nested_arrays" do
      assert_json '[[["deep","another_depp"],["second_deep"]]]' do |json|
        json.element [%w(deep another_depp), %w(second_deep)]
      end
    end
    should "test_nested_arrays_crosscheck" do
      assert_raises(MiniTest::Assertion) do
        assert_json '[[["deep","another_depp"],["second_deep"]]]' do |json|
          json.element [%w(deep wrong_another_depp), %w(second_deep)]
        end
      end
      assert_raises(MiniTest::Assertion) do
        assert_json '[[["deep","another_depp"],["second_deep"]]]' do |json|
          json.element [%w(deep another_depp), %w(wrong_second_deep)]
        end
      end
    end

    should "test_hash_with_value_array" do
      assert_json '{"key":["value1","value2"]}' do |json|
        json.element 'key', %w(value1 value2)
      end
    end
    should "test_hash_with_value_array_crosscheck_wrong_key" do
      assert_raises(MiniTest::Assertion) do
        assert_json '{"key":["value1","value2"]}' do |json|
          json.element 'wrong_key', %w(value1 value2)
        end
      end
    end
    should "test_hash_with_value_array_crosscheck_wrong_value1" do
      assert_raises(MiniTest::Assertion) do
        assert_json '{"key":["value1","value2"]}' do |json|
          json.element 'key', %w(wrong_value1 value2)
        end
      end
    end
    should "test_hash_with_value_array_crosscheck_wrong_value2" do
      assert_raises(MiniTest::Assertion) do
        assert_json '{"key":["value1","value2"]}' do |json|
          json.element 'key', %w(value1 wrong_value2)
        end
      end
    end
  end # arrays

  context "array of hashes" do
    should "test_hash_with_array_of_hashes" do
      assert_json '{"key":[{"inner_key1":"value1"},{"inner_key2":"value2"}]}' do |json|
        json.element 'key' do
          json.element 'inner_key1', 'value1'
          json.element 'inner_key2', 'value2'
        end
      end
    end
    should "test_hash_with_array_of_hashes_crosscheck_inner_key" do
      assert_raises(MiniTest::Assertion) do
        assert_json '{"key":[{"inner_key1":"value1"},{"inner_key2":"value2"}]}' do |json|
          json.element 'key' do
            json.element 'wrong_inner_key1', 'value1'
          end
        end
      end
    end
    should "test_hash_with_array_of_hashes_crosscheck_inner_value" do
      assert_raises(MiniTest::Assertion) do
        assert_json '{"key":[{"inner_key1":"value1"},{"inner_key2":"value2"}]}' do |json|
          json.element 'key' do
            json.element 'inner_key1', 'wrong_value1'
          end
        end
      end
    end

    should "test_array_with_two_hashes" do
      assert_json '[{"key1":"value1"}, {"key2":"value2"}]' do |json|
        json.element 'key1', 'value1'
        json.element 'key2', 'value2'
      end
    end
    should "test_array_with_nested_hashes" do
      assert_json '[{"key1":{"key2":"value2"}}]' do |json|
        json.element 'key1' do
          json.element 'key2', 'value2'
        end
      end
    end
    should "test_array_with_two_hashes_crosscheck" do
      assert_raises(MiniTest::Assertion) do
        assert_json '[{"key1":"value1"}, {"key2":"value2"}]' do |json|
          json.element 'wrong_key1', 'value1'
          json.element 'key2', 'value2'
        end
      end
      assert_raises(MiniTest::Assertion) do
        assert_json '[{"key1":"value1"}, {"key2":"value2"}]' do |json|
          json.element 'key1', 'value1'
          json.element 'key2', 'wrong_value2'
        end
      end
    end
  end # array with hashes

  context "nested hashes" do
    should "test_nested_hashes" do
      assert_json '{"outer_key":{"key":{"inner_key":"value"}}}' do |json|
        json.element 'outer_key' do
          json.element 'key' do
            json.element 'inner_key', 'value'
          end
        end
      end
    end
    should "test_nested_hashes_crosscheck" do
      assert_raises(MiniTest::Assertion) do
        assert_json '{"outer_key":{"key":{"inner_key":"value"}}}' do |json|
          json.element 'wrong_outer_key'
        end
      end
      assert_raises(MiniTest::Assertion) do
        assert_json '{"outer_key":{"key":{"inner_key":"value"}}}' do |json|
          json.element 'outer_key' do
            json.element 'key' do
              json.element 'inner_key', 'wrong_value'
            end
          end
        end
      end
    end
  end # nested hashes

  context "real life examples" do
    should "test_real_xws" do
      assert_json '[{"contact_request":{"sender_id":"3","receiver_id":"2","id":1}}]' do |json|
        json.element 'contact_request' do
          json.element 'sender_id', '3'
          json.element 'receiver_id', '2'
          json.element 'id', 1
        end
      end

      test_json = <<JSON
[{"private_message":{"sender":{"display_name":"first last"},"receiver_id":"2","body":"body"}}]
JSON
      assert_json test_json do |json|
        json.element 'private_message' do
          json.element 'sender' do
            json.element 'display_name', 'first last'
          end
          json.element 'receiver_id', '2'
          json.element 'body', 'body'
        end
      end
    end
  end # real life examples

  context "not enough elements" do
    should "test_not_enough_elements_in_array" do
      assert_raises(MiniTest::Assertion) do
        assert_json '["one","two"]' do |json|
          json.element "one"
          json.element "two"
          json.element "three"
        end
      end
    end

    should "test_not_enough_elements_in_hash_array" do
      assert_raises(MiniTest::Assertion) do
        assert_json '{"key":[{"key1":"value1"}, {"key2":"value2"}]}' do |json|
          json.element 'key' do
            json.element 'key1', 'value1'
            json.element 'key2', 'value2'
            json.element 'key3'
          end
        end
      end
    end
  end # not enough elements
end
