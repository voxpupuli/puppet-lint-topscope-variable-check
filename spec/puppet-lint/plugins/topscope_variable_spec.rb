require 'spec_helper'

describe 'topscope_variable' do
  let(:msg) { 'use $foo::bar instead of $::foo::bar' }
  context 'with fix disabled' do
    context 'with correct topscope' do
      let(:code) do
        <<-PUP.strip_heredoc
          class foo::blub {
            notify { 'foo'
              message => $foo::bar
            }
          }
        PUP
      end

      it 'should not detect any problems' do
        expect(problems).to have(0).problem
      end
    end

    context 'with incorrect topscope' do
      let(:code) do
        <<-PUP.strip_heredoc
          class foo::blub {
            notify { 'foo'
              message => $::foo::bar
            }
          }
        PUP
      end

      it 'should detect one problem' do
        expect(problems).to have(1).problem
      end
    end

    context 'with correct topscope in params' do
      let(:code) do
        <<-PUP.strip_heredoc
          class foo::blub(
            String $foo = $params::foo
          ) {
            # ...
          }
        PUP
      end

      it 'should not detect any problems' do
        expect(problems).to have(0).problem
      end
    end

    context 'with incorrect topscope in params' do
      let(:code) do
        <<-PUP.strip_heredoc
          class foo::blub(
            String $foo = $::foo::params::foo
          ) {
            # ...
          }
        PUP
      end

      it 'should detect one problem' do
        expect(problems).to have(1).problem
      end
    end

    context 'with a fact that has been used improperly' do
      let(:code) do
        <<-PUP.strip_heredoc
          class foo::blub {
            notify { 'foo'
                message => $blub::bar
            }
           }
        PUP
      end

      it 'should not detect any problems' do
        expect(problems).to have(0).problem
      end
    end
  end

  context 'with fix disabled' do
    before do
      PuppetLint.configuration.fix = true
    end

    after do
      PuppetLint.configuration.fix = false
    end

    context 'with correct topscope' do
      let(:code) do
        <<-PUP.strip_heredoc
          class foo::blub {
            notify { 'foo'
            message => $foo::bar
          }
        }
        PUP
      end

      it 'should not detect any problems' do
        expect(problems).to have(0).problem
      end
    end

    context 'with incorrect topscope' do
      let(:code) do
        <<-PUP.strip_heredoc
          class foo::blub {
            notify { 'foo'
              message => $::foo::bar
            }
          }
        PUP
      end

      it 'should detect one problem' do
        expect(problems).to have(1).problem
      end

      it 'should fix the problem' do
        expect(problems).to contain_fixed(msg).on_line(3).in_column(16)
      end

      it 'should add :: after the $' do
        expect(manifest).to eq <<-PUP.strip_heredoc
          class foo::blub {
            notify { 'foo'
              message => $foo::bar
            }
          }
        PUP
      end
    end
  end
end
