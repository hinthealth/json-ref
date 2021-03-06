# JSON Ref

[![Build Status](https://travis-ci.org/nmerouze/json-ref.png)](https://travis-ci.org/nmerouze/json-ref)
[![Code Climate](https://codeclimate.com/github/nmerouze/json-ref.png)](https://codeclimate.com/github/nmerouze/json-ref)

Partial implementation of [JSON Ref](http://tools.ietf.org/html/draft-pbryan-zyp-json-ref-00) draft. The URI can only contain a fragment pointing to a value inside the document at this moment.

## Install

Add this line to your application's Gemfile:

    gem 'json-ref'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json-ref

## Usage

```ruby
origin_doc = { 'title' => 'foobar', 'ref_title' => { '$ref' => '#/title' } }
JSONRef.new(origin_doc).expand
# => 
{ 'title' => 'foobar', 'ref_title' => 'foobar' }
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright (c) 2013 Nicolas Mérouze

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.