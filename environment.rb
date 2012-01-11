require 'rubygems'
require 'bundler'
Bundler.setup
Bundler.require

require 'logger'
$LOAD_PATH << './lib'
require 'parser'
require 'startup'

if File.exist?('config/newreclic.yml')
  NewRelic::Control.instance.init_plugin(:env => Sinatra::Application.environment.to_s)
end

ENVIRONMENT = ENV['DB'] || ENV['ENV'] || 'development'
db_config = YAML.load(File.read('db/config.yml'))[ENVIRONMENT]

def show_log
  logger = Logger.new(STDOUT)
  logger.level = Logger::DEBUG
  ActiveRecord::Base.logger = logger
end
show_log if $SHOW_LOG # logging cannot be activate after connection has been established

ActiveRecord::Base.establish_connection(db_config)
