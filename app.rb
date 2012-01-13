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
  @page = (params[:page] || 1).to_i
  @prev = @page > 1 ? @page - 1 : 1
  @next = @page + 1
  @startups = Startup.order("score desc")
  	.paginate(:page => params[:page], :per_page => 10)
  erb :index
end
