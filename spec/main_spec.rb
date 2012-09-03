require File.dirname(__FILE__) + '/spec_helper'
set :environment, :test
include Rack::Test::Methods
use Rack::Session::Cookie

def app
  @app ||= Sinatra::Application
end

describe "Application" do
  before {3.times {FactoryGirl.create(:post)}}

  it "should load the home page" do
    get '/'
    last_response.status.should ==  200
  end

  it "should load the login page" do
    get '/auth'
    last_response.status.should ==  200
  end

  it "should get all posts" do
    Post.all.should have(3).item
  end

end

describe "Admin" do

  before(:each) do
    params = {"password" => "qwert123"}
    post '/auth', params
  end

  it "is able to create a new post" do
    get "/posts/new"
    params = {"title" => "New post", "body" => "Lorem ipsum"}
    post "/posts", params
    follow_redirect!
    last_response.body.include?("Your post has been created.").should be_true
  end

  it "is able to edit the existing post" do
    @post = FactoryGirl.create(:post)
    get "/#{@post.id}/edit"
    params = {"title" => "Update post", "body" => "New description"}
    post "/#{@post.id}/", params
    follow_redirect!
    last_response.body.include?("Your post has been updated.").should be_true
  end

  it "is able to comment on the existing post" do
    @post = FactoryGirl.create(:post)
    get "/#{@post.id}/"
    params = {"user"=>"admin","body"=>"test"}
    post "/#{@post.id}/comment", params
    follow_redirect!
    last_response.body.include?("Your comment has been created.").should be_true
  end

  it "is able to logout" do
    get "/logout"
    follow_redirect!
    last_response.body.include?("Create new post").should be_false
  end

end

describe "Anonymous" do

  it "is not able to create a new post" do
    get '/'
    last_response.body.include?('Create new post').should be_false
  end

  it "is able to comment on the existing post" do
    @post = FactoryGirl.create(:post)
    get "/#{@post.id}/"
    params = {"user"=>"David","body"=>"test"}
    post "/#{@post.id}/comment", params
    follow_redirect!
    last_response.body.include?("Your comment has been created.").should be_true
  end

end
