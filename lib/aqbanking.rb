require "aqbanking/version"
require "aqbanking/user"
require "aqbanking/account"

module AqBanking
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
      args: ['--acceptvalidcerts', '--noninteractive',
             '--charset=utf-8', "--cfgfile=#{AqBanking.config}"]
    }.merge(options)
    "aqhbci-tool4 #{options[:args].join(' ')} #{command}"
  end

  def aqcli(command, options = {})
    options = {
      pinfile: nil,
      args: ['--acceptvalidcerts', '--noninteractive',
             '--charset=utf-8', "--cfgdir=#{AqBanking.config}"]
    }.merge(options)
    "aqbanking-cli #{options[:args].join(' ')} #{command}"
  end
end
