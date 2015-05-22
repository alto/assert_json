require_relative './test_helper'

# nodoc
class AssertJsonHasNoUnexpectedKeysTest < Minitest::Test
  include AssertJson

  context "has_only" do
    should "test_on_root_object" do
      assert_json '{"keyA":"value","keyB":"value"}' do
        has_only
        has 'keyA'
        has 'keyB'
      end
    end

    should "test_on_root_object_failure" do
      err = assert_raises(MiniTest::Assertion) do
        assert_json '{"keyA":"value","keyB":"value"}' do
          has_only
          has 'keyA', 'value'
        end
      end
      assert_equal 'element root has unexpected keys: keyB', err.message
    end

    should "test_on_root_object_with_sub_object" do
      assert_json '{"keyA":{"subKeyA":"value","subKeyB":"value"},"keyB":"value"}' do
        has_only
        has 'keyA' do
          has 'subKeyA'
          has 'subKeyB'
        end
        has 'keyB'
      end
    end

    should "test_on_root_object_with_sub_object_failure" do
      err = assert_raises(MiniTest::Assertion) do
        assert_json '{"keyA":{"subKeyA":"value","subKeyB":"value"},"keyB":"value"}' do
          has_only
          has 'keyA' do
            has 'subKeyA'
            has 'subKeyB'
          end
        end
      end
      assert_equal 'element root has unexpected keys: keyB', err.message
    end

    should "test_on_sub_object" do
      assert_json '{"keyA":{"subKeyA":"value","subKeyB":"value"},"keyB":"value"}' do
        has 'keyA' do
          has_only
          has 'subKeyA'
          has 'subKeyB'
        end
      end
    end

    should "test_on_sub_object_failure" do
      err = assert_raises(MiniTest::Assertion) do
        assert_json '{"keyA":{"subKeyA":"value","subKeyB":"value"},"keyB":"value"}' do
          has 'keyA' do
            has_only
            has 'subKeyA'
          end
        end
      end
      assert_equal 'element keyA has unexpected keys: subKeyB', err.message
    end

    should "test_on_root_array_of_objects" do
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
        has_only
        item 0 do
          has :id, 1
          has :key, 'test'
          has :name, 'test'
        end
      end
    end

    should "test_on_root_array_of_objects_failure" do
      err = assert_raises(MiniTest::Assertion) do
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
          has_only
          item 0 do
            has :id, 1
            has :key, 'test'
          end
        end
      end
      assert_equal 'element 0 has unexpected keys: name', err.message
    end
  end
end
