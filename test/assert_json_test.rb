require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class AssertJsonTest < Test::Unit::TestCase
  include AssertJson

  def test_string
    assert_json '"key"' do |json|
      json.element 'key'
    end
  end
  def test_string_crosscheck
    assert_raises(MiniTest::Assertion) do
      assert_json '"key"' do |json|
        json.element 'wrong_key'
      end
    end
  end
  def test_regular_expression_for_strings
    assert_json '"string"' do |json|
      json.element /tri/
    end
  end
  def test_regular_expression_for_hash_values
    assert_json '{"key":"value"}' do |json|
      json.element 'key', /alu/
    end
  end
  
  def test_single_hash
    assert_json '{"key":"value"}' do |json|
      json.element 'key', 'value'
    end
  end
  def test_single_hash_crosscheck_for_key
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":"value"}' do |json|
        json.element 'wrong_key', 'value'
      end
    end
  end
  def test_single_hash_crosscheck_for_value
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":"value"}' do |json|
        json.element 'key', 'wrong_value'
      end
    end
  end
  
  def test_not_element
    assert_json '{"key":"value"}' do |json|
      json.element 'key', 'value'
      json.not_element 'key_not_included'
    end
  end
  def test_not_element_crosscheck
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":"value"}' do |json|
        json.not_element 'key'
      end
    end
  end
  
  def test_array
    assert_json '["value1","value2","value3"]' do |json|
      json.element 'value1'
      json.element 'value2'
      json.element 'value3'
    end
  end
  def test_not_element_array
    assert_json '["value1","value2"]' do |json|
      json.element 'value1'
      json.element 'value2'
      json.not_element 'value3'
    end
  end
  def test_array_crosscheck_order
    assert_raises(MiniTest::Assertion) do
      assert_json '["value1","value2","value3"]' do |json|
        json.element 'value2'
      end
    end
  end
  def test_array_crosscheck_for_first_item
    assert_raises(MiniTest::Assertion) do
      assert_json '["value1","value2","value3"]' do |json|
        json.element 'wrong_value1'
      end
    end
  end
  def test_array_crosscheck_for_second_item
    assert_raises(MiniTest::Assertion) do
      assert_json '["value1","value2","value3"]' do |json|
        json.element 'value1'
        json.element 'wrong_value2'
      end
    end
  end
  
  def test_nested_arrays
    assert_json '[[["deep","another_depp"],["second_deep"]]]' do |json|
      json.element [["deep","another_depp"],["second_deep"]]
    end
  end
  def test_nested_arrays_crosscheck
    assert_raises(MiniTest::Assertion) do
      assert_json '[[["deep","another_depp"],["second_deep"]]]' do |json|
        json.element [["deep","wrong_another_depp"],["second_deep"]]
      end
    end
    assert_raises(MiniTest::Assertion) do
      assert_json '[[["deep","another_depp"],["second_deep"]]]' do |json|
        json.element [["deep","another_depp"],["wrong_second_deep"]]
      end
    end
  end
  
  def test_hash_with_value_array
    assert_json '{"key":["value1","value2"]}' do |json|
      json.element 'key', ['value1', 'value2']
    end
  end
  def test_hash_with_value_array_crosscheck_wrong_key
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":["value1","value2"]}' do |json|
        json.element 'wrong_key', ['value1', 'value2']
      end
    end
  end
  def test_hash_with_value_array_crosscheck_wrong_value1
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":["value1","value2"]}' do |json|
        json.element 'key', ['wrong_value1', 'value2']
      end
    end
  end
  def test_hash_with_value_array_crosscheck_wrong_value2
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":["value1","value2"]}' do |json|
        json.element 'key', ['value1', 'wrong_value2']
      end
    end
  end

  def test_hash_with_array_of_hashes
    assert_json '{"key":[{"inner_key1":"value1"},{"inner_key2":"value2"}]}' do |json|
      json.element 'key' do
        json.element 'inner_key1', 'value1'
        json.element 'inner_key2', 'value2'
      end
    end
  end
  def test_hash_with_array_of_hashes_crosscheck_inner_key
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":[{"inner_key1":"value1"},{"inner_key2":"value2"}]}' do |json|
        json.element 'key' do
          json.element 'wrong_inner_key1', 'value1'
        end
      end
    end
  end
  def test_hash_with_array_of_hashes_crosscheck_inner_value
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":[{"inner_key1":"value1"},{"inner_key2":"value2"}]}' do |json|
        json.element 'key' do
          json.element 'inner_key1', 'wrong_value1'
        end
      end
    end
  end
  
  def test_array_with_two_hashes
    assert_json '[{"key1":"value1"}, {"key2":"value2"}]' do |json|
      json.element 'key1', 'value1'
      json.element 'key2', 'value2'
    end
  end
  def test_array_with_nested_hashes
    assert_json '[{"key1":{"key2":"value2"}}]' do |json|
      json.element 'key1' do
        json.element 'key2', 'value2'
      end
    end
  end
  def test_array_with_two_hashes_crosscheck
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
  
  def test_nested_hashes
    assert_json '{"outer_key":{"key":{"inner_key":"value"}}}' do |json|
      json.element 'outer_key' do
        json.element 'key' do
          json.element 'inner_key', 'value'
        end
      end
    end
  end
  def test_nested_hashes_crosscheck
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

  def test_real_xws
    assert_json '[{"contact_request":{"sender_id":"3","receiver_id":"2","id":1}}]' do |json|
      json.element 'contact_request' do
        json.element 'sender_id', '3'
        json.element 'receiver_id', '2'
        json.element 'id', 1
      end
    end

    assert_json '[{"private_message":{"sender":{"display_name":"first last"},"receiver_id":"2","body":"body"}}]' do |json|
      json.element 'private_message' do
        json.element 'sender' do
          json.element 'display_name', 'first last'
        end
        json.element 'receiver_id', '2'
        json.element 'body', 'body'
      end
    end
  end

  def test_not_enough_elements_in_array
    assert_raises(MiniTest::Assertion) do
      assert_json '["one","two"]' do |json|
        json.element "one"
        json.element "two"
        json.element "three"
      end
    end
  end

  def test_not_enough_elements_in_hash_array
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

end
