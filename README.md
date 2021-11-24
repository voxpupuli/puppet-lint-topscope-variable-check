puppet-lint-topscope-variable-check
========================
[![License](https://img.shields.io/github/license/voxpupuli/puppet-lint-topscope-variable-check.svg)](https://github.com/voxpupuli/puppet-lint-topscope-variable-check/blob/master/LICENSE)
[![Test](https://github.com/voxpupuli/puppet-lint-topscope-variable-check/actions/workflows/test.yml/badge.svg)](https://github.com/voxpupuli/puppet-lint-topscope-variable-check/actions/workflows/test.yml)
[![Release](https://github.com/voxpupuli/puppet-lint-topscope-variable-check/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-lint-topscope-variable-check/actions/workflows/release.yml)
[![RubyGem Version](https://img.shields.io/gem/v/puppet-lint-topscope-variable-check.svg)](https://rubygems.org/gems/puppet-lint-topscope-variable-check)
[![RubyGem Downloads](https://img.shields.io/gem/dt/puppet-lint-topscope-variable-check.svg)](https://rubygems.org/gems/puppet-lint-topscope-variable-check)

A puppet-lint plugin to check that topscope variables in a class do not begin with $::

## Installation

### From the command line
```shell
$ gem install puppet-lint-topscope-variable-check
```

### In a Gemfile
```ruby
gem 'puppet-lint-topscope-variable-check', require: false
```

## Checks

#### What you have done

```puppet
class foo::blub {
  notify { 'foo':
    message => $::foo::bar,
  }
}
```

or
```puppet
class foo::blub(
  String $foo = $::foo::params::foo
) {
  # ...
}
```

#### What you should have done

```puppet
class foo::blub {
  notify { 'foo'
    message => $foo::bar,
  }
}
```

and

```puppet
class foo::blub(
  String $foo = $foo::params::foo
) {
  # ...
}
```

#### Disabling the check

To disable this check, you can add `--no-topscope_variable-check` to your puppet-lint command line:
```shell
$ puppet-lint --no-topscope_variable-checks
```

Alternatively, if you are calling puppet-lint via the Rake task, you should insert the following line into your `Rakefile`:

```ruby
PuppetLint.configuration.send('disable_topscope_variable')
```
## Limitations

The fix function of this plugin does not work when the variable is used in a string and hasn't been enclosed with `{}`.
For example:

``` puppet
$foo = "/etc/$::foobar::path/test"
```

Note: The [Variables Not Enclosed](http://puppet-lint.com/checks/variables_not_enclosed/) check can fix the missing braces and then the fix from this plugin should work.

## Transfer Notice

This plugin and github repository was originally developed and maintained by [Sixt](https://www.sixt.com/).
On 2021/11/24 the github project was transferred to [Voxpupuli](https://voxpupuli.org/) for ongoing improvement and maintenance.

Previously: https://github.com/Sixt/puppet-lint-topscope-variable-check

## License
```
MIT License

Copyright (c) 2018 Sixt GmbH & Co. Autovermietung KG

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
