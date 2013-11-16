require 'spec_helper'

describe AqBanking do
  context '#with_secure_pin' do
    let(:user) { double('User', bank: '123', user_id: '456') }
    let(:pin) { 'secure' }

    it 'creates a temporary pinfile with 400' do
      AqBanking::with_secure_pin(user, pin) do |f|
        f.should_not be_nil
        expect(File).to exist(f.path)
        File.read(f.path).should == "PIN_123_456 = \"secure\"\n"
      end
    end

    it 'deletes the file afterwards' do
      path = nil
      AqBanking::with_secure_pin(user, pin) do |f|
        path = f.path.strip
      end
      expect(File).not_to exist(path)
    end
  end

  context '#aqhbci' do
    it 'returns a aqhbci-tool4 command' do
      AqBanking::aqhbci('test').should == "aqhbci-tool4 --acceptvalidcerts --noninteractive --charset=utf-8 --cfgfile=. test"
    end
  end

  context '#aqcli' do
    it 'returns a aqbanking-cli command' do
      AqBanking::aqcli('test').should == "aqbanking-cli --acceptvalidcerts --noninteractive --charset=utf-8 --cfgdir=. test"
    end
  end

  context '#generate_arguments' do
    it 'escapes value arguments' do
      AqBanking.send(:generate_arguments, cfgfile: '/tmp/some weird dir').should == '--cfgfile=/tmp/some\\ weird\\ dir'
    end

    it 'returns only allowed arguments' do
      AqBanking.send(:generate_arguments, weird: true).should == ''
    end

    it 'returns flags if the option is true' do
      AqBanking.send(:generate_arguments, noninteractive: true).should == '--noninteractive'
    end

    it 'does not return flags if the option is false' do
      AqBanking.send(:generate_arguments, noninteractive: false).should == ''
    end
  end

end
