require 'environment'

error_logger = Logger.new('log/errors.log', 3, 10*1024*1024)
error do
  error = request.env['sinatra.error']
  info = "Application error\n#{error}\n#{error.backtrace.join("\n")}"

  error_logger.info info
  Kernel.puts info

  'Application error'
end

set :views, 'views'
set :public_folder, 'public' # shotgun serves them but rackup does not ...

get "/" do
  erb :index
end
