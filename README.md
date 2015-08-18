# AssertJson #

[![Build Status](https://travis-ci.org/alto/assert_json.svg?branch=master)](https://travis-ci.org/alto/assert_json)

Test your JSON strings.

## Installation ##

```sh
cd path/to/your/rails-project
./script/plugin install git://github.com/alto/assert_json.git
```

Or if you prefer [bundler](http://getbundler.com)

```sh
# in your Gemfile
gem 'assert_json'
```


## Usage ##

```ruby
class MyActionTest < ActionController::TestCase
  include AssertJson

  def test_my_action
    get :my_action, :format => 'json'
    # => @response.body= '{"key":[{"inner_key1":"value1"},{"inner_key2":"value2"}, {'special-key': null}]}'

    assert_json(@response.body) do
      has :key do
        has :inner_key1, 'value1'
        has :inner_key2, /lue2/
      end
      has 'special-key', nil
      has_not :key_not_included
    end
  end

end
```

Arrays are little bit special. If you want to test single items (or skip others) you
use `item(i)` to select the item to test, like this

```ruby
assert_json '[{"id":1, "key":"test", "name":"test"}, {"id":2, "key":"test", "name":"test"}, {"id":3, "key":"test", "name":"test"}]' do
  item 0 do
    has :id, 1
    has :key, 'test'
    has :name, 'test'
  end
  item 2 do
    has 'id', 3
  end
end
```

You can also check the size of arrays like this

```ruby
assert_json '["value1", "value2"]' do
  has_length_of 2
end
```

To test that objects have the declared set of properties and nothing more,
include `has_only` at any level, like this

```ruby
assert_json '[{"id":1, "key":"test", "name":"test"}, {"id":2, "key":"test", "name":"test"}, {"id":3, "key":"test", "name":"test"}]' do
  has_only
  item 0 do
    has :id, 1
    has :key, 'test'
    has :name, 'test'
  end
  item 1 do
    has 'id', 2
    has 'key', 'test'
  end
end

# Failure: element 1 has unexpected keys: name
```


## Changelog ##

Look at the [CHANGELOG](https://github.com/alto/assert_json/blob/master/CHANGELOG.md) for details.

## Authors ##

[Thorsten Böttger](http://github.com/alto)


## License ##

The MIT License

Copyright (c) 2009-2014 [Thorsten Böttger](http://mt7.de/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
