# Ciesta

[![Build Status](https://travis-ci.org/nulldef/ciesta.svg?branch=master)](https://travis-ci.org/nulldef/ciesta)
[![Coverage Status](https://coveralls.io/repos/github/nulldef/ciesta/badge.svg?branch=master&rand=23)](https://coveralls.io/github/nulldef/ciesta?branch=master)
[![Gem Version](https://badge.fury.io/rb/ciesta.svg)](https://badge.fury.io/rb/ciesta)

Create simple form objects

Supported Ruby 2.2.0+

You should keep it in mind that here uses [dry-validation](https://github.com/dry-rb/dry-validation) and [dry-types](https://github.com/dry-rb/dry-types) for validation and typification respectively.

- [Installation](#installation)
- [Usage](#usage)
  - [Basic case](#basic-case)
  - [Syncing](#syncing)
  - [Validation](#validation)
  - [Advanced field declaration](#advanced-field-declaration)
    - [Types](#types)
    - [Default value](#default-value)
    - [Virtual field](#virtual-field)
  - [Values mass update](#values-mass-update)
- [Contributing](#contributing)
- [License](#license)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "ciesta"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ciesta


## Usage

### Basic case
For example will be used user object with `name` and `age` attributes:

```ruby
User = Struct.new(:name, :age)

user = User.new(nil, nil)
```

For setting and syncing new values let's create a form object:

```ruby
class Form
  include Ciesta

  field :name
  field :age

  def age
    super.to_i
  end
end

form = Form.new(user)
```

```ruby
form.name = "John"
form.age = "33"
form.sync!

user.name # => "John"
user.age  # => 33
```

### Syncing
You can pass a block to sync method to do some stuff with object after syncing.

```ruby
form.sync! do |user|
  user.make_happy!
end
```
Both `sync` and `sync!` provide this DSL.

### Validation
For validating incoming values you can use `validate` method:

```ruby
class Form
  include Ciesta

  field :name
  field :age

  validate do
    required(:name).filled
    required(:age).filled(gt?: 18)
  end
end

form = Form.new(user)
```

An attempt to sync with invalid form will raise `Ciesta::FormNotValid` error.

```ruby
form.age = 15
form.valid? # => false
form.sync!  # => raises Ciesta::FormNotValid
form.errors # => { age: ["must be greater than 18"] }
...
form.age = 42
form.sync!  # => true

user.age    # => 42
```

### Advanced field declaration

#### Types
You can define the type of a field using `Ciesta::Types` namespace.

```ruby
field :age, type: Ciesta::Types::Coercible::Int
...
form.age = "42"
form.age # => 42
```

Default type is `Ciesta::Types::Any`.

#### Default value
If your attribute wasn’t set yet, but value is already in use, one can set a `default` option to avoid exceptions.

```ruby
field :age, default: 42
...
form.age # => 42
```

Default value can also be a `Proc`, wich will be called in the object context.

```ruby
class User
  def default_age
    42
  end
end
```

```ruby
field :age, default: -> { default_age }
...
form.age # => 42
```

### Virtual field
You can declare field as "virtual". It means that when you call `sync!` it will not raise an error "model attribute is not defined".

```ruby
User = Struct.new(:name)
...
field :age, virtual: true
...
form.age = "42"
form.age # => 42
form.sync! # => true
```

## Values mass update
There are two methods for form fields mass update: `assign` and `assign!`.

```ruby
form.assign!(name: "Neo", age: 30)
form.sync!
...
user.name # => "Neo"
user.age  # => 30
```

`assign!` method will raise `Ciesta::FieldNotDefined` error if one of the passed attributes is not declared in the form.

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/nulldef/ciesta](https://github.com/nulldef/ciesta).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
