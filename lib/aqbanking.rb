require 'aqbanking/version'
require 'aqbanking/commander'
require 'aqbanking/user'
require 'aqbanking/account'
require 'aqbanking/transaction'

module AqBanking
  GLOBAL_ARGS = {
    acceptvalidcerts: :flag,
    noninteractive: :flag,
    charset: :value,
    cfgdir: :value,
    cfgfile: :value,
    pinfile: :value,
  }

  CMD_ARGS = {
    tokentype: :value,
    bank: :value,
    user: :value,
    server: :value,
    username: :value
  }

  class << self

    def config=(path)
      @config = path
    end

    def config
      @config ||= '.'
    end

    def aqhbci(command, options = {})
      options = {
        pinfile: nil,
        acceptvalidcerts: true,
        noninteractive: true,
        charset: 'utf-8',
        cfgfile: AqBanking.config
      }.merge(options)
      [
       'aqhbci-tool4',
       generate_arguments(options, GLOBAL_ARGS),
       command,
       generate_arguments(options, CMD_ARGS)
      ].join(' ').strip
    end

    def aqcli(command, options = {})
      options = {
        pinfile: nil,
        acceptvalidcerts: true,
        noninteractive: true,
        charset: 'utf-8',
        cfgdir: AqBanking.config
      }.merge(options)
      [
       'aqbanking-cli',
       generate_arguments(options, GLOBAL_ARGS),
       command,
       generate_arguments(options, CMD_ARGS)
      ].join(' ').strip
    end

    private
    def generate_arguments(hash, args)
      args.keys.map do |key|
        if args[key] == :flag && hash[key]
          "--#{key.to_s}"
        elsif args[key] == :value && hash[key]
          "--#{key.to_s}=#{Shellwords.escape(hash[key])}"
        end
      end.compact.join(' ')
    end

  end

end
