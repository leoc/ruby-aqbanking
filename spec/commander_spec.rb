require 'spec_helper'

describe AqBanking::Commander do

  describe '::with_pin' do
    let(:user) { double('User', bank: '123', user_id: '456') }
    let(:pin) { 'secure' }

    it 'creates a temporary pinfile with 400' do
      AqBanking::Commander.with_pin(user, pin) do
        File.read(pinfile).should == "PIN_123_456 = \"secure\"\n"
      end
    end

    it 'deletes the file afterwards' do
      path = nil
      AqBanking::Commander.with_pin(user, pin) do
        path = pinfile
      end
      expect(File).not_to exist(path)
    end

    it 'executes the given block inside a commander context' do
      context = nil
      AqBanking::Commander.with_pin(user, pin) do
        context = self
      end
      context.should(be_a AqBanking::Commander::Context)
    end
  end

  context '::aqhbci' do
    it 'returns a aqhbci-tool4 command' do
      AqBanking::Commander::aqhbci('test').should == 'aqhbci-tool4 --acceptvalidcerts --noninteractive --charset=utf-8 --cfgfile=. test'
    end
  end

  context '::aqcli' do
    it 'returns a aqbanking-cli command' do
      AqBanking::Commander::aqcli('test').should == 'aqbanking-cli --acceptvalidcerts --noninteractive --charset=utf-8 --cfgdir=. test'
    end
  end

  context '::generate_arguments' do
    it 'escapes value arguments' do
      AqBanking::Commander.send(:generate_arguments, { cfgfile: '/tmp/some weird dir' }, AqBanking::Commander::GLOBAL_ARGS).
        should == '--cfgfile=/tmp/some\\ weird\\ dir'
    end

    it 'returns only allowed arguments' do
      AqBanking::Commander.send(:generate_arguments, { weird: true }, AqBanking::Commander::GLOBAL_ARGS).should == ''
    end

    it 'returns flags if the option is true' do
      AqBanking::Commander.send(:generate_arguments, { noninteractive: true }, AqBanking::Commander::GLOBAL_ARGS).
        should == '--noninteractive'
    end

    it 'does not return flags if the option is false' do
      AqBanking::Commander.send(:generate_arguments, {noninteractive: false }, AqBanking::Commander::GLOBAL_ARGS).should == ''
    end
  end

end
