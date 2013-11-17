module AqBanking
  # The commander class is used by all other AqBanking classes to
  # execute aqbanking commandline utilities.
  class Commander
    class << self
      def with_pin(user, pin, &block)
        f = Tempfile.new("pin_#{user.bank}_#{user.user_id}", '/tmp')
        File.chmod(0400, f.path)

        f.write "PIN_#{user.bank}_#{user.user_id} = \"#{pin}\"\n"
        f.flush

        yield f if block_given?

        f.close
        f.unlink
      end
    end
  end
end
