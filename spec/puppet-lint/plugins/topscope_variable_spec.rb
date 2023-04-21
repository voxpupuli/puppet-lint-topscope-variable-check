require 'spec_helper'

describe 'topscope_variable' do
  let(:msg) { 'use $foo::bar instead of $::foo::bar' }

  context 'with fix disabled' do
    context 'with correct topscope' do
      let(:code) do
        <<~PUP
          class foo::blub {
            notify { 'foo':
              message => $foo::bar
            }
          }
        PUP
      end

      it 'does not detect any problems' do
        expect(problems).to have(0).problem
      end
    end

    context 'with incorrect topscope' do
      let(:code) do
        <<~PUP
          class foo::blub {
            notify { 'foo':
              message => $::foo::bar
            }
          }
        PUP
      end

      it 'detects one problem' do
        expect(problems).to have(1).problem
      end
    end

    context 'with incorrect topscope from external module' do
      let(:code) do
        <<~PUP
          class profile::foo {
            notify { 'foo':
              message => $::some_component_module::bar
            }
          }
        PUP
      end

      it 'detects one problem' do
        expect(problems).to have(1).problem
      end
    end

    context 'with correct topscope in params' do
      let(:code) do
        <<~PUP
          class foo::blub(
            String $foo = $params::foo
          ) {
            # ...
          }
        PUP
      end

      it 'does not detect any problems' do
        expect(problems).to have(0).problem
      end
    end

    context 'with incorrect topscope in params' do
      let(:code) do
        <<~PUP
          class foo::blub(
            String $foo = $::foo::params::foo
          ) {
            # ...
          }
        PUP
      end

      it 'detects one problem' do
        expect(problems).to have(1).problem
      end
    end

    context 'with a fact that has been used improperly' do
      let(:code) do
        <<~PUP
          class foo::blub {
            notify { 'foo':
              message => $::operatingsystem
            }
          }
        PUP
      end

      it 'does not detect any problems' do
        expect(problems).to have(0).problem
      end
    end

    context 'with a fact that has been used improperly in params' do
      let(:code) do
        <<~PUP
          class foo::blub(
            String $foo = $::operatingsystem
          ) {
            # ...
          }
        PUP
      end

      it 'does not detect any problems' do
        expect(problems).to have(0).problem
      end
    end
  end

  context 'with fix enabled' do
    before do
      PuppetLint.configuration.fix = true
    end

    after do
      PuppetLint.configuration.fix = false
    end

    context 'with correct topscope' do
      let(:code) do
        <<~PUP
          class foo::blub {
            notify { 'foo':
              message => $foo::bar
            }
          }
        PUP
      end

      it 'does not detect any problems' do
        expect(problems).to have(0).problem
      end
    end

    context 'with incorrect topscope' do
      let(:code) do
        <<~PUP
          class foo::blub {
            notify { 'foo':
              message => $::foo::bar
            }
          }
        PUP
      end

      it 'detects one problem' do
        expect(problems).to have(1).problem
      end

      it 'fixes the problem' do
        expect(problems).to contain_fixed(msg).on_line(3).in_column(16)
      end

      it 'removes :: after the $' do
        expect(manifest).to eq <<~PUP
          class foo::blub {
            notify { 'foo':
              message => $foo::bar
            }
          }
        PUP
      end
    end

    context 'with incorrect topscope from external module' do
      let(:code) do
        <<~PUP
          class profile::foo {
            notify { 'foo':
              message => $::some_component_module::bar
            }
          }
        PUP
      end

      it 'detects one problem' do
        expect(problems).to have(1).problem
      end

      it 'fixes the problem' do
        expect(problems).to contain_fixed('use $some_component_module::bar instead of $::some_component_module::bar').on_line(3).in_column(16)
      end

      it 'removes :: after the $' do
        expect(manifest).to eq <<~PUP
          class profile::foo {
            notify { 'foo':
              message => $some_component_module::bar
            }
          }
        PUP
      end
    end

    context 'with incorrect topscope in quoted variable' do
      let(:code) do
        <<~PUP
          class foo::blub {
            notify { 'foo':
              message => ">${::foo::bar}<"
            }
          }
        PUP
      end

      it 'detects one problem' do
        expect(problems).to have(1).problem
      end

      it 'fixes the problem' do
        expect(problems).to contain_fixed(msg).on_line(3).in_column(20)
      end

      it 'removes :: after the $' do
        expect(manifest).to eq <<~PUP
          class foo::blub {
            notify { 'foo':
              message => ">${foo::bar}<"
            }
          }
        PUP
      end
    end
  end

  context 'without a class scope' do
    let(:code) do
      <<~PUP
        include ::foo
      PUP
    end

    it 'does not detect any problems' do
      expect(problems).to have(0).problem
    end
  end
end
