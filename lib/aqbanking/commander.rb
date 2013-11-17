require 'aqbanking/commander/context'

module AqBanking
  # The commander class is used by all other AqBanking classes to
  # execute aqbanking commandline utilities.
  class Commander
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
      def with_pin(user, pin, &block)
        f = Tempfile.new("pin_#{user.bank}_#{user.user_id}", '/tmp')
        File.chmod(0400, f.path)

        f.write "PIN_#{user.bank}_#{user.user_id} = \"#{pin}\"\n"
        f.flush

        Context.new(f.path, &block).execute

        f.close
        f.unlink
      end

      def aqhbci(command, options = {})
        options = {
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
end
