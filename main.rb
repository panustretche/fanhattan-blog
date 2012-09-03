require 'rubygems'
require 'sinatra'
require 'mongo_mapper'
require 'sinatra/flash'
require 'encrypted_cookie'

use Rack::Session::Cookie, :key => 'fanhattan_admin', :secret => '51d6d976913ace58'
MongoMapper.connection = Mongo::Connection.new('localhost', 27017)
MongoMapper.database = "fanhattan_blog"

configure do
  require 'ostruct'
	Blog = OpenStruct.new(
		:title => 'Fanhattan blog',
		:author => 'Panu',
		:url_base => 'http://localhost:4567/',
		:admin_password => 'qwert123'
	)
end

error do
	e = request.env['sinatra.error']
	puts e.to_s
	puts e.backtrace.join("\n")
	"Application error"
end

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/models')
require 'post'
require 'comment'

helpers do
	def admin?
    session[:fanhattan_admin] == 'admin'
	end

	def auth
		halt [ 401, 'Not authorized' ] unless admin?
	end
end

layout 'layout'

### Public

# List all post
get '/' do
	posts = Post.all.reverse
	erb :index, :locals => { :posts => posts }
end

# Get a post by id
get '/:id/' do
  post = Post.find(params[:id])
	halt [ 404, "Page not found" ] unless post
	@title = post.title
  erb :post, :locals => { :post => post }
end

# Post comment on that post
post '/:id/comment' do
  post = Post.find(params[:id])
  halt [ 404, "Page not found" ] unless post
  post.comments.build({:body => params[:body], :user => params[:user]})
  post.save ? flash[:notice] = "Your comment has been created." : flash[:error] = "Your comment has not been created."
  redirect post.url
end

### Admin

# Admin login
get '/auth' do
	erb :auth
end

# Authenticate admin
post '/auth' do
  params[:password] == Blog.admin_password ? session[:fanhattan_admin] = 'admin'
: flash[:error] = 'Invalid password'
  redirect '/'
end

# Admin logout
get '/logout' do
  session[:fanhattan_admin] = ''
  redirect '/'
end

# Get a post for creating
get '/posts/new' do
	auth
	erb :edit, :locals => { :post => Post.new, :url => '/posts' }
end

# Create new post
post '/posts' do
	auth
	post = Post.new :title => params[:title], :body => params[:body], :created_at => Time.now
  post.save ? flash[:notice] = "Your post has been created." : flash[:error] = "Your post has not been created."
  redirect post.url
end

# Get a post by id for updating
get '/:id/edit' do
	auth
	post = Post.find(params[:id])
	halt [ 404, "Page not found" ] unless post
	erb :edit, :locals => { :post => post, :url => post.url }
end

# Update an existing post
post '/:id/' do
	auth
	post = Post.find(params[:id])
  halt [ 404, "Page not found" ] unless post
	post.title = params[:title]
	post.body = params[:body]
	post.save ? flash[:notice] = "Your post has been updated." : flash[:error] = "Your post has not been updated."
	redirect post.url
end
