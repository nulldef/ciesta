# Ciesta

[![Gem Version](https://badge.fury.io/rb/ciesta.svg)](https://badge.fury.io/rb/ciesta)
[![Coverage Status](https://coveralls.io/repos/github/nulldef/ciesta/badge.svg?branch=master&rand=123)](https://coveralls.io/github/nulldef/ciesta?branch=master)
[![Build Status](https://travis-ci.org/nulldef/ciesta.svg?branch=master)](https://travis-ci.org/nulldef/ciesta)

Create simple form objects

Supported Ruby 2.2.0+

- [Installation](#installation)
- [Usage](#usage)
  - [Basic usage](#basic-usage)
  - [Assign values](#assign-values)
  - [Syncing attributes](#syncing-attributes)
  - [Types](#types)
- [Contributing](#contributing)
- [License](#license)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ciesta'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install statum

## Usage

### Basic usage

For validation it uses [dry-validation](https://github.com/dry-rb/dry-validation) under the hood. You can use all features of validation provided there.

```ruby
User = Struct.new(:name, :age)

class Form < Ciesta::Form
  field :name
  field :age

  validate do
    required(:name).filled
    required(:age).filled(gt?: 18)
  end
end
```

And use it

```ruby
user = User.new("John", nil)
form = Form.new(user)
form.valid?(age: 10) # => false
form.valid?(age: 20) # => true
```

### Assign values

You can assign values to form with two methods `assign!` and `assign`

```ruby
class Form < Ciesta::Form
  field :bar
end

form.assign!(foo: 1, bar: 2) # => raises Ciesta::FieldNotDefined
...
form.assign(foo: 1, bar: 2)
form.foo # => 1
```

You can pass attributes directly to `valid?` method. In this case `assing` method will be used.

### Syncing attributes

You can use methods `sync` and `sync!` for mapping form values to the object. The difference is only that the second one will raise error if form is invalid.

```ruby
form.valid?(age: 10)
form.sync! # => raises Ciesta::NotValid
form.sync  # => returns nil
```

### Types

You can provide the type of each field for ciercing or checking one. All types provided by [dry-types](https://github.com/dry-rb/dry-types) but in gem's namespace.

```ruby
class Form < Ciesta::Form
  field :foo, type: Ciesta::Types::Coercible::String
end

# ...
form.assign(foo: 1) # => true
form.foo            # => "1"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/nulldef/ciesta](https://github.com/nulldef/ciesta).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
