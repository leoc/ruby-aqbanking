require 'spec_helper'

describe AqBanking do

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
      AqBanking.send(:generate_arguments, { cfgfile: '/tmp/some weird dir' }, AqBanking::GLOBAL_ARGS).
                     should == '--cfgfile=/tmp/some\\ weird\\ dir'
    end

    it 'returns only allowed arguments' do
      AqBanking.send(:generate_arguments, { weird: true }, AqBanking::GLOBAL_ARGS).should == ''
    end

    it 'returns flags if the option is true' do
      AqBanking.send(:generate_arguments, { noninteractive: true }, AqBanking::GLOBAL_ARGS).
        should == '--noninteractive'
    end

    it 'does not return flags if the option is false' do
      AqBanking.send(:generate_arguments, {noninteractive: false }, AqBanking::GLOBAL_ARGS).should == ''
    end
  end

end
