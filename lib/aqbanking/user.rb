require 'open3'

module AqBanking
  class User
    attr_accessor :name, :bank, :user_id, :server, :hbciversion

    def initialize(options = {})
      User.complain_missing_parameters(options)
    end

    class << self

      def add(options = {})
        pin = options.delete(:pin)
        options = {
          tokentype: 'pintan',
          hbciversion: 300,
          context: '1'
        }.merge(options)

        complain_missing_parameters(options)

        command = Commander.aqhbci('adduser', options)
        stdin, stdout, stderr, status = Open3.popen3(command)

        unless status.value.success?
          fail "Unable to create user: \n#{stderr.read}"
        end
        user = User.new(options)

        if user && pin
          Commander.with_pin(user, pin) do |f|
            sysid_command = Commander.aqhbci('getsysid',
                                             user: options[:user],
                                             pinfile: f.path.strip)
            stdin, stdout, stderr, wait_thr = Open3.popen3(sysid_command)
            unless wait_thr.value.success?
              fail "Unable to get sysid:\n#{stderr.read}"
            end
          end
        end

        user
      end

      def remove(options = {})
        fail 'Missing options: user' unless options[:user]
        command = Commander.aqhbci('deluser', user: options[:user])
        _, _, stderr, status = Open3.popen3(command)
        unless status.value.success?
          fail "Unable to remove user:\n#{stderr.read}"
        end
      end

      def complain_missing_parameters(hash)
        missing = []
        missing << :bank unless hash[:bank]
        missing << :user unless hash[:user]
        missing << :server unless hash[:server]
        missing << :username unless hash[:username]
        fail "Missing options: #{missing.join(', ')}" unless missing.empty?
      end
    end
  end
end
