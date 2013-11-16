require 'spec_helper'

describe AqBanking do
  include AqBanking

  context '#with_secure_pin' do
    let(:user) { double('User', bank: '123', user_id: '456') }
    let(:pin) { 'secure' }

    it 'creates a temporary pinfile with 400' do
      with_secure_pin(user, pin) do |f|
        f.should_not be_nil
        expect(File).to exist(f.path)
        File.read(f.path).should == "PIN_123_456 = \"secure\"\n"
      end
    end

    it 'deletes the file afterwards' do
      path = nil
      with_secure_pin(user, pin) do |f|
        path = f.path.strip
      end
      expect(File).not_to exist(path)
    end
  end

  context '#aqhbci' do
    it 'returns a aqhbci-tool4 command' do
      aqhbci('test').should == "aqhbci-tool4 --acceptvalidcerts --noninteractive --charset=utf-8 --cfgfile=. test"
    end
  end

  context '#aqcli' do
    it 'returns a aqbanking-cli command' do
      aqcli('test').should == "aqbanking-cli --acceptvalidcerts --noninteractive --charset=utf-8 --cfgdir=. test"
    end
  end

end
