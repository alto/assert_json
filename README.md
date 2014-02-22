# AssertJson #

Test your JSON strings.

## Installation ##

```sh
cd path/to/your/rails-project
./script/plugin install git://github.com/xing/assert_json.git
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
    # => @response.body= '{"key":[{"inner_key1":"value1"},{"inner_key2":"value2"}]}'

    assert_json(@response.body) do
      has 'key' do
        has 'inner_key1', 'value1'
        has 'inner_key2', /lue2/
      end
      has_not 'key_not_included'
    end
  end

end
```

## Changelog ##

Look at the [CHANGELOG](https://github.com/xing/assert_json/blob/master/CHANGELOG.md) for details.

## Authors ##

[Thorsten Böttger](http://github.com/alto),


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
