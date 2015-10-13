require 'rubygems'

require 'active_support/core_ext/string/inflections'
require 'aws-sdk'
require 'configs'
require 'logger'
require 'pathname'
require 'rainbow'
require 'rainbow/ext/string'

require 'milkrun/build'
require 'milkrun/build_list'
require 'milkrun/changelog'
require 'milkrun/hockey_app'
require 'milkrun/s3_package'
require 'milkrun/version_code'
require 'milkrun/version_name'

module Milkrun
  def self.app_dir
    project_dir + 'app'
  end

  def self.bucket
    'android-ksr-builds'
  end

  def self.error(message)
    log.error message.color(:red)
  end

  def self.project_dir
    Pathname.new(File.dirname(__FILE__)).parent
  end

  def self.log
    return @log if @log

    @log = Logger.new(STDOUT)
    @log.formatter = proc do |severity, datetime, progname, msg|
      time = datetime.strftime("%H:%M:%S")
      "[#{time} Milkrun]: #{msg}\n"
    end
    @log
  end

  # Logs a message, then prompts the user to enter a value for a label. If label is nil,
  # the user is asked to confirm.
  #
  # Returns the input String.
  def self.prompt(message, label: nil)
    say message
    input_text = label ? "#{label}: " :  "Press enter to confirm"
    print input_text.color(:yellow)
    STDIN.gets.chomp
  end

  def self.say(message)
    log.info message.color(:green)
  end

  def self.s3_client
    @s3_client ||= Aws::S3::Client.new(
      credentials: Aws::Credentials.new(Configs[:s3][:access_key], Configs[:s3][:secret_key]),
      region: 'us-east-1'
    )
  end
end
