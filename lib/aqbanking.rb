require "aqbanking/version"
require "aqbanking/user"
require "aqbanking/account"

module AqBanking
  ARGS = {
    acceptvalidcerts: :flag,
    noninteractive: :flag,
    charset: :value,
    cfgdir: :value,
    cfgfile: :value,
    pinfile: :value
  }

  def self.config=(path)
    @config = path
  end

  def self.config
    @config ||= '.'
  end

  def with_secure_pin(user, pin, &block)
    f = Tempfile.new("pin_#{user.bank}_#{user.user_id}", '/tmp')
    File.chmod(0400, f.path)

    f.write "PIN_#{user.bank}_#{user.user_id} = \"#{pin}\"\n"
    f.flush

    yield f if block_given?

    f.close
    f.unlink
  end

  def aqhbci(command, options = {})
    options = {
      pinfile: nil,
      acceptvalidcerts: true,
      noninteractive: true,
      charset: 'utf-8',
      cfgfile: AqBanking.config
    }.merge(options)
    "aqhbci-tool4 #{generate_arguments(options)} #{command}"
  end

  def aqcli(command, options = {})
    options = {
      pinfile: nil,
      acceptvalidcerts: true,
      noninteractive: true,
      charset: 'utf-8',
      cfgdir: AqBanking.config
    }.merge(options)
    "aqbanking-cli #{generate_arguments(options)} #{command}"
  end

  private
  def generate_arguments(hash)
    ARGS.keys.map do |key|
      if ARGS[key] == :flag && hash[key]
        "--#{key.to_s}"
      elsif ARGS[key] == :value && hash[key]
        "--#{key.to_s}=#{hash[key]}"
      end
    end.compact.join(' ')
  end
end
