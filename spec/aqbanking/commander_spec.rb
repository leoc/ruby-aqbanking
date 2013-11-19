require 'spec_helper'

describe AqBanking::Commander do

  describe '::with_pin' do
    let(:user) { double('User', bank: '123', user: '456') }
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
    it 'executes aqhbci-tool4 command' do
      expect(AqBanking::Commander).to receive(:execute).with('aqhbci-tool4', 'test', anything)
      AqBanking::Commander.aqhbci('test')
    end
  end

  context '::aqcli' do
    it 'executes aqbanking-cli command' do
      expect(AqBanking::Commander).to receive(:execute).with('aqbanking-cli', 'test', anything)
      AqBanking::Commander.aqcli('test')
    end
  end

  context '::execute' do
    it 'calls open3 with correct command' do
      expect(Open3).to receive(:popen3).with('process cmd') do
        [nil, double('string', read: 'output string'),
         nil, double(value: double(:success? => true))]
      end
      AqBanking::Commander.execute('process', 'cmd', {})
    end

    it 'returns the output and the status' do
      status = double('exitstatus', success?: true)
      expect(Open3).to receive(:popen3).with('process cmd') do
        [nil, double('string', read: 'output string'),
         nil, double(value: status)]
      end
      AqBanking::Commander.execute('process', 'cmd', {}).should ==
        ['output string', status]
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
