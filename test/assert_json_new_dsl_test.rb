require 'test_helper'

class AssertJsonNewDslTest < Minitest::Test
  include AssertJson

  def test_string
    assert_json '"key"' do
      has 'key'
    end
  end
  def test_string_crosscheck
    assert_raises(MiniTest::Assertion) do
      assert_json '"key"' do
        has 'wrong_key'
      end
    end
  end
  def test_regular_expression_for_strings
    assert_json '"string"' do
      has /tri/
    end
  end
  def test_regular_expression_for_hash_values
    assert_json '{"key":"value"}' do
      has 'key', /alu/
    end
  end

  def test_single_hash
    assert_json '{"key":"value"}' do
      has 'key', 'value'
    end
  end
  def test_single_hash_with_outer_variable
    @values = {'value' => 'value'}
    assert_json '{"key":"value"}' do
      has 'key', @values['value']
    end
  end
  def test_single_hash_crosscheck_for_key
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":"value"}' do
        has 'wrong_key', 'value'
      end
    end
  end
  def test_single_hash_crosscheck_for_value
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":"value"}' do
        has 'key', 'wrong_value'
      end
    end
  end

  def test_has_not
    assert_json '{"key":"value"}' do
      has 'key', 'value'
      has_not 'key_not_included'
    end
  end
  def test_has_not_crosscheck
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":"value"}' do
        has_not 'key'
      end
    end
  end

  def test_array
    assert_json '["value1","value2","value3"]' do
      has 'value1'
      has 'value2'
      has 'value3'
    end
  end
  def test_has_not_array
    assert_json '["value1","value2"]' do
      has 'value1'
      has 'value2'
      has_not 'value3'
    end
  end
  def test_array_crosscheck_order
    assert_raises(MiniTest::Assertion) do
      assert_json '["value1","value2","value3"]' do
        has 'value2'
      end
    end
  end
  def test_array_crosscheck_for_first_item
    assert_raises(MiniTest::Assertion) do
      assert_json '["value1","value2","value3"]' do
        has 'wrong_value1'
      end
    end
  end
  def test_array_crosscheck_for_second_item
    assert_raises(MiniTest::Assertion) do
      assert_json '["value1","value2","value3"]' do
        has 'value1'
        has 'wrong_value2'
      end
    end
  end

  def test_nested_arrays
    assert_json '[[["deep","another_depp"],["second_deep"]]]' do
      has [["deep","another_depp"],["second_deep"]]
    end
  end
  def test_nested_arrays_crosscheck
    assert_raises(MiniTest::Assertion) do
      assert_json '[[["deep","another_depp"],["second_deep"]]]' do
        has [["deep","wrong_another_depp"],["second_deep"]]
      end
    end
    assert_raises(MiniTest::Assertion) do
      assert_json '[[["deep","another_depp"],["second_deep"]]]' do
        has [["deep","another_depp"],["wrong_second_deep"]]
      end
    end
  end

  def test_hash_with_value_array
    assert_json '{"key":["value1","value2"]}' do
      has 'key', ['value1', 'value2']
    end
  end
  def test_hash_with_value_array_crosscheck_wrong_key
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":["value1","value2"]}' do
        has 'wrong_key', ['value1', 'value2']
      end
    end
  end
  def test_hash_with_value_array_crosscheck_wrong_value1
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":["value1","value2"]}' do
        has 'key', ['wrong_value1', 'value2']
      end
    end
  end
  def test_hash_with_value_array_crosscheck_wrong_value2
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":["value1","value2"]}' do
        has 'key', ['value1', 'wrong_value2']
      end
    end
  end

  def test_hash_with_array_of_hashes
    assert_json '{"key":[{"inner_key1":"value1"},{"inner_key2":"value2"}]}' do
      has 'key' do
        has 'inner_key1', 'value1'
        has 'inner_key2', 'value2'
      end
    end
  end
  def test_hash_with_array_of_hashes_crosscheck_inner_key
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":[{"inner_key1":"value1"},{"inner_key2":"value2"}]}' do
        has 'key' do
          has 'wrong_inner_key1', 'value1'
        end
      end
    end
  end
  def test_hash_with_array_of_hashes_crosscheck_inner_value
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":[{"inner_key1":"value1"},{"inner_key2":"value2"}]}' do
        has 'key' do
          has 'inner_key1', 'wrong_value1'
        end
      end
    end
  end


  def test_array_with_multi_item_hashes
    assert_json '[{"id":1, "key":"test", "name":"test"}, {"id":2, "key":"test", "name":"test"}, {"id":3, "key":"test", "name":"test"}]' do
      item 0 do
        has 'id', 1
        has 'key', 'test'
        has 'name', 'test'
      end
      item 2 do
        has 'id', 3
      end
    end
  end
  def test_array_with_multi_item_hashes_crosscheck
    assert_raises(MiniTest::Assertion) do
      assert_json '[{"id":1, "key":"test", "name":"test"}, {"id":2, "key":"test", "name":"test"}, {"id":3, "key":"test", "name":"test"}]' do
        item 0 do
          has 'id', 1
          has 'key', 'test'
          has 'name', 'test'
        end
        item 2 do
          has 'id', 2
        end
      end
    end
  end


  def test_array_with_two_hashes
    assert_json '[{"key1":"value1"}, {"key2":"value2"}]' do
      has 'key1', 'value1'
      has 'key2', 'value2'
    end
  end
  def test_array_with_nested_hashes
    assert_json '[{"key1":{"key2":"value2"}}]' do
      has 'key1' do
        has 'key2', 'value2'
      end
    end
  end
  def test_array_with_two_hashes_crosscheck
    assert_raises(MiniTest::Assertion) do
      assert_json '[{"key1":"value1"}, {"key2":"value2"}]' do
        has 'wrong_key1', 'value1'
        has 'key2', 'value2'
      end
    end
    assert_raises(MiniTest::Assertion) do
      assert_json '[{"key1":"value1"}, {"key2":"value2"}]' do
        has 'key1', 'value1'
        has 'key2', 'wrong_value2'
      end
    end
  end

  def test_nested_hashes
    assert_json '{"outer_key":{"key":{"inner_key":"value"}}}' do
      has 'outer_key' do
        has 'key' do
          has 'inner_key', 'value'
        end
      end
    end
  end
  def test_nested_hashes_crosscheck
    assert_raises(MiniTest::Assertion) do
      assert_json '{"outer_key":{"key":{"inner_key":"value"}}}' do
        has 'wrong_outer_key'
      end
    end
    assert_raises(MiniTest::Assertion) do
      assert_json '{"outer_key":{"key":{"inner_key":"value"}}}' do
        has 'outer_key' do
          has 'key' do
            has 'inner_key', 'wrong_value'
          end
        end
      end
    end
  end

  def test_real_xws
    assert_json '[{"contact_request":{"sender_id":"3","receiver_id":"2","id":1}}]' do
      has 'contact_request' do
        has 'sender_id', '3'
        has 'receiver_id', '2'
        has 'id', 1
      end
    end

    assert_json '[{"private_message":{"sender":{"display_name":"first last"},"receiver_id":"2","body":"body"}}]' do
      has 'private_message' do
        has 'sender' do
          has 'display_name', 'first last'
        end
        has 'receiver_id', '2'
        has 'body', 'body'
      end
    end
  end

  def test_not_enough_hass_in_array
    assert_raises(MiniTest::Assertion) do
      assert_json '["one","two"]' do
        has "one"
        has "two"
        has "three"
      end
    end
  end

  def test_not_enough_hass_in_hash_array
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key":[{"key1":"value1"}, {"key2":"value2"}]}' do
        has 'key' do
          has 'key1', 'value1'
          has 'key2', 'value2'
          has 'key3'
        end
      end
    end
  end

  def test_boolean
    assert_json '{"key": true}' do
      has 'key', true
    end
    assert_json '{"key": false}' do
      has 'key', false
    end
  end

  def test_boolean_crosscheck
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key": false}' do
        has 'key', true
      end
    end
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key": true}' do
        has 'key', false
      end
    end
  end

  def test_null
    assert_json '{"key": null}' do
      has 'key', nil
    end
  end

  def test_not_null
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key": 1}' do
        has 'key', nil
      end
    end
  end

  def test_null_crosscheck
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key": null}' do
        has_not 'key'
      end
    end
  end

  def test_symbol_as_a_value
    assert_json '{"key": "text"}' do
      has :key, :text
    end
    assert_raises(MiniTest::Assertion) do
      assert_json '{"key": "badtext"}' do
        has :key, :text
      end
    end
  end

  def test_symbol_as_a_key
    assert_json '{"sym": true, "text": "1"}' do
      has :sym, true
      has :text, /\d+/
      has_not :bad_sym
    end
    assert_json '{"sym": false, "text": "2", "topkey": {"subkey": "value1"}}' do
      has :sym, false
      has :text, /\d+/
      has_not :bad_sym
      has :topkey do
        has :subkey, :value1
      end
    end
  end

  def test_symbol_as_string_value
    assert_json '{"topkey": {"subkey": "value1"}}' do
      has :topkey do
        has :subkey do
          has :value1
        end
      end
    end
  end


  def test_symbol_as_a_key_crossheck
    assert_raises(MiniTest::Assertion) do
      assert_json '{"text": "1"}' do
        has :sym, true  #this should fail
        has :text, /\d+/
        has_not :bad_sym
      end
    end

    assert_raises(MiniTest::Assertion) do
      assert_json '{"sym": false, "text": "abc"}' do
        has :sym, false
        has :text, /\d+/   #this should fail
        has_not :bad_sym
      end
    end

    assert_raises(MiniTest::Assertion) do
      assert_json '{"sym": false}' do
        has_not :sym
      end
    end
  end

  def test_regex_with_number
    assert_json '{"number": 1}' do
      has :number, /^\d+$/
    end
  end

end
