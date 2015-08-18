require 'test_helper'

# nodoc
class AssertJsonNewDslTest < Minitest::Test
  include AssertJson

  context "strings" do
    should "test_string" do
      assert_json '"key"' do
        has 'key'
      end
    end
    should "test_string_crosscheck" do
      assert_raises(MiniTest::Assertion) do
        assert_json '"key"' do
          has 'wrong_key'
        end
      end
    end
    should "test_regular_expression_for_strings" do
      assert_json '"string"' do
        has(/tri/)
      end
    end
    should "test_regular_expression_for_hash_values" do
      assert_json '{"key":"value"}' do
        has 'key', /alu/
      end
    end
  end # strings

  context "hashes" do
    should "test_single_hash" do
      assert_json '{"key":"value"}' do
        has 'key', 'value'
      end
    end
    should "test_single_hash_with_outer_variable" do
      @values = { 'value' => 'value' }
      assert_json '{"key":"value"}' do
        has 'key', @values['value']
      end
    end
    should "test_single_hash_crosscheck_for_key" do
      assert_raises(MiniTest::Assertion) do
        assert_json '{"key":"value"}' do
          has 'wrong_key', 'value'
        end
      end
    end
    should "test_single_hash_crosscheck_for_value" do
      assert_raises(MiniTest::Assertion) do
        assert_json '{"key":"value"}' do
          has 'key', 'wrong_value'
        end
      end
    end

    should "test_has_not" do
      assert_json '{"key":"value"}' do
        has 'key', 'value'
        has_not 'key_not_included'
      end
    end
    should "test_has_not_crosscheck" do
      assert_raises(MiniTest::Assertion) do
        assert_json '{"key":"value"}' do
          has_not 'key'
        end
      end
    end
  end # hashes

  context "arrays" do
    should "test_array" do
      assert_json '["value1","value2","value3"]' do
        has 'value1'
        has 'value2'
        has 'value3'
      end
    end
    should "test_has_not_array" do
      assert_json '["value1","value2"]' do
        has 'value1'
        has 'value2'
        has_not 'value3'
      end
    end
    should "test_array_crosscheck_order" do
      assert_raises(MiniTest::Assertion) do
        assert_json '["value1","value2","value3"]' do
          has 'value2'
        end
      end
    end
    should "test_array_crosscheck_for_first_item" do
      assert_raises(MiniTest::Assertion) do
        assert_json '["value1","value2","value3"]' do
          has 'wrong_value1'
        end
      end
    end
    should "test_array_crosscheck_for_second_item" do
      assert_raises(MiniTest::Assertion) do
        assert_json '["value1","value2","value3"]' do
          has 'value1'
          has 'wrong_value2'
        end
      end
    end

    should "test_nested_arrays" do
      assert_json '[[["deep","another_depp"],["second_deep"]]]' do
        has [%w(deep another_depp), %w(second_deep)]
      end
    end
    should "test_nested_arrays_crosscheck" do
      assert_raises(MiniTest::Assertion) do
        assert_json '[[["deep","another_depp"],["second_deep"]]]' do
          has [%w(deep wrong_another_depp), %w(second_deep)]
        end
      end
      assert_raises(MiniTest::Assertion) do
        assert_json '[[["deep","another_depp"],["second_deep"]]]' do
          has [%w(deep another_depp), %w(wrong_second_deep)]
        end
      end
    end

    should "test_array_has_length_of" do
      assert_json '["value1","value2"]' do
        has_length_of 2
      end
    end

    should "test_array_has_length_of_error" do
      assert_raises(MiniTest::Assertion) do
        assert_json '["single value"]' do
          has_length_of 2
        end
      end
    end

    should "test_nested_array_has_length_of" do
      assert_json '["value1",["value2.1","value2.2","value3.3"]]' do
        has_length_of 2
        item 1 do
          has_length_of 3
        end
      end
    end

    should "test_itemised_nested_array" do
      json = '[["deep","another_depp"],["second_deep"]]'
      assert_json json do
        item 0 do
          item 0 do
            has 'deep'
          end
          item 1 do
            has 'another_depp'
          end
        end
        item 1 do
          has 'second_deep'
        end
      end
    end
    should "test_itemised_nested_array_crosscheck" do
      json = '[["deep","another_depp"],["second_deep"]]'
      assert_json json do
        item 0 do
          item 0 do
            has 'deep'
          end
          item 1 do
            assert_raises(MiniTest::Assertion) do
              has 'wrong_item_value'
            end
          end
        end
        item 1 do
          assert_raises(MiniTest::Assertion) do
            has 'unknown_item_value'
          end
        end
      end
    end
  end # arrays

  context "hashes with arrays" do
    should "test_hash_with_value_array" do
      assert_json '{"key":["value1","value2"]}' do
        has 'key', %w(value1 value2)
      end
    end
    should "test_hash_with_value_array_crosscheck_wrong_key" do
      assert_raises(MiniTest::Assertion) do
        assert_json '{"key":["value1","value2"]}' do
          has 'wrong_key', %w(value1 value2)
        end
      end
    end
    should "test_hash_with_value_array_crosscheck_wrong_value1" do
      assert_raises(MiniTest::Assertion) do
        assert_json '{"key":["value1","value2"]}' do
          has 'key', %w(wrong_value1 value2)
        end
      end
    end
    should "test_hash_with_value_array_crosscheck_wrong_value2" do
      assert_raises(MiniTest::Assertion) do
        assert_json '{"key":["value1","value2"]}' do
          has 'key', %w(value1 wrong_value2)
        end
      end
    end

    should "test_hash_with_array_of_hashes" do
      assert_json '{"key":[{"inner_key1":"value1"},{"inner_key2":"value2"}]}' do
        has 'key' do
          has 'inner_key1', 'value1'
          has 'inner_key2', 'value2'
        end
      end
    end
    should "test_hash_with_array_of_hashes_crosscheck_inner_key" do
      assert_raises(MiniTest::Assertion) do
        assert_json '{"key":[{"inner_key1":"value1"},{"inner_key2":"value2"}]}' do
          has 'key' do
            has 'wrong_inner_key1', 'value1'
          end
        end
      end
    end
    should "test_hash_with_array_of_hashes_crosscheck_inner_value" do
      assert_raises(MiniTest::Assertion) do
        assert_json '{"key":[{"inner_key1":"value1"},{"inner_key2":"value2"}]}' do
          has 'key' do
            has 'inner_key1', 'wrong_value1'
          end
        end
      end
    end
  end # hashes with arrays

  context "arrays with hashes" do
    should "test_array_with_multi_item_hashes" do
      json = <<JSON
[
  {
    "id":1,
    "key":"test",
    "name":"test"
  },{
    "id":2,
    "key":"test",
    "name":"test"
  },{
    "id":3,
    "key":"test",
    "name":"test"
  }
]
JSON
      assert_json json do
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
    should "test_array_with_multi_item_hashes_crosscheck" do
      assert_raises(MiniTest::Assertion) do
        json = <<JSON
[
  {
    "id":1,
    "key":"test",
    "name":"test"
  },{
    "id":2,
    "key":"test",
    "name":"test"
  },{
    "id":3,
    "key":"test",
    "name":"test"
  }
]
JSON
        assert_json json do
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

    should "test_array_with_two_hashes" do
      assert_json '[{"key1":"value1"}, {"key2":"value2"}]' do
        has 'key1', 'value1'
        has 'key2', 'value2'
      end
    end
    should "test_array_with_nested_hashes" do
      assert_json '[{"key1":{"key2":"value2"}}]' do
        has 'key1' do
          has 'key2', 'value2'
        end
      end
    end
    should "test_array_with_two_hashes_crosscheck" do
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
  end # arrays with hashes

  context "nested hashes" do
    should "test_nested_hashes" do
      assert_json '{"outer_key":{"key":{"inner_key":"value"}}}' do
        has 'outer_key' do
          has 'key' do
            has 'inner_key', 'value'
          end
        end
      end
    end
    should "test_nested_hashes_crosscheck" do
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
  end # nested hashes

  context "real life examples" do
    should "test_complex_example" do
      json = <<JSON
{
  "count":2,
  "total_count":3,
  "results":[
    {
      "id":14,
      "tags":[
        "tag1",
        "tag2"
      ],
      "created_at":"2014-10-14T00:50:39Z",
      "updated_at":"2014-10-14T00:51:39Z"
    },{
      "id":15,
      "tags":[
        "tag3",
        "tag4"
      ],
      "created_at":"2014-10-15T00:50:39Z",
      "updated_at":"2014-10-15T00:51:39Z"
    }
  ]
}
JSON

      assert_json json do
        has 'count', 2
        has 'total_count', 3
        has 'results' do
          item 0 do
            has 'id', 14
            has 'tags' do
              item 0 do
                has 'tag1'
              end
              item 1 do
                has 'tag2'
              end
            end
            has 'created_at', '2014-10-14T00:50:39Z'
            has 'updated_at', '2014-10-14T00:51:39Z'
          end
        end
      end
    end

    should "test_real_xws" do
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
  end # real life examples

  context "not enough elements" do
    should "test_not_enough_hass_in_array" do
      assert_raises(MiniTest::Assertion) do
        assert_json '["one","two"]' do
          has "one"
          has "two"
          has "three"
        end
      end
    end

    should "test_not_enough_hass_in_hash_array" do
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
  end # not enough elements

  context "boolean" do
    should "test_boolean" do
      assert_json '{"key": true}' do
        has 'key', true
      end
      assert_json '{"key": false}' do
        has 'key', false
      end
    end

    should "test_boolean_crosscheck" do
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
  end # boolean

  context "null" do
    should "test_null" do
      assert_json '{"key": null}' do
        has 'key', nil
      end
    end

    should "test_not_null" do
      assert_raises(MiniTest::Assertion) do
        assert_json '{"key": 1}' do
          has 'key', nil
        end
      end
    end

    should "test_null_crosscheck" do
      assert_raises(MiniTest::Assertion) do
        assert_json '{"key": null}' do
          has_not 'key'
        end
      end
    end
  end # null

  context "symbols" do
    should "test_symbol_as_a_value" do
      assert_json '{"key": "text"}' do
        has :key, :text
      end
      assert_raises(MiniTest::Assertion) do
        assert_json '{"key": "badtext"}' do
          has :key, :text
        end
      end
    end

    should "test_symbol_as_a_key" do
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

    should "test_symbol_as_string_value" do
      assert_json '{"topkey": {"subkey": "value1"}}' do
        has :topkey do
          has :subkey do
            has :value1
          end
        end
      end
    end

    should "test_symbol_as_a_key_crossheck" do
      assert_raises(MiniTest::Assertion) do
        assert_json '{"text": "1"}' do
          has :sym, true  # this should fail
          has :text, /\d+/
          has_not :bad_sym
        end
      end

      assert_raises(MiniTest::Assertion) do
        assert_json '{"sym": false, "text": "abc"}' do
          has :sym, false
          has :text, /\d+/   # this should fail
          has_not :bad_sym
        end
      end

      assert_raises(MiniTest::Assertion) do
        assert_json '{"sym": false}' do
          has_not :sym
        end
      end
    end
  end # symbols

  context "regular expressions for numbers" do
    should "test_regex_with_number" do
      assert_json '{"number": 1}' do
        has :number, /^\d+$/
      end
    end
  end
end
