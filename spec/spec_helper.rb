require 'coveralls'
Coveralls.wear!

require 'puppet-lint'
PuppetLint::Plugins.load_spec_helper

# strip left spaces from heredoc
# this emulates the behaviour of the ~ heredoc from ruby 2.3
class String
  def strip_heredoc
    gsub(/^#{scan(/^\s*/).min_by(&:length)}/, '')
  end
end
