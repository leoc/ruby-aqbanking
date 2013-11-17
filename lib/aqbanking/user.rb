require 'open3'

module AqBanking
  class User
    attr_accessor :username, :bank, :user, :server, :hbciversion, :context

    def initialize(options = {})
      User.complain_missing_parameters(:username, :bank, :user, options)
      @username = options[:username]
      @bank = options[:bank]
      @user = options[:user]
      @server = options[:server]
      @hbciversion = options[:hbciversion]
      @context = options[:context]
    end

    class << self

      def add(options = {})
        pin = options.delete(:pin)
        options = {
          tokentype: 'pintan',
          hbciversion: 300,
          context: '1'
        }.merge(options)

        complain_missing_parameters(:username, :bank, :user, :server, options)

        Commander.aqhbci('adduser', options)

        user = User.new(options)

        if user && pin
          Commander.with_pin(user, pin) do |f|
            aqhbci('getsysid', user: options[:user])
          end
        end

        user
      end

      def remove(options = {})
        fail 'Missing options: user' unless options[:user]
        _, status = Commander.aqhbci('deluser', user: options[:user])
        status.success?
      end

      def complain_missing_parameters(*args)
        hash = args.last.is_a?(Hash) ? args.pop : {}
        missing = []
        args.each do |param|
          missing << param unless hash[param]
        end
        fail "Missing options: #{missing.join(', ')}" unless missing.empty?
      end
    end
  end
end
