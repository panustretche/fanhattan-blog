require File.dirname(__FILE__) + '/spec_helper'
set :environment, :test

describe Post do
  describe ".create" do

    it "should create a new instance given a valid attribute" do
      FactoryGirl.build(:post).new_record?
    end

    it "should require title" do
      FactoryGirl.build(:post, title: nil, body:"Lorem ipsum").should_not be_valid
    end

    it "should require body" do
      FactoryGirl.build(:post, title: "My post", body:nil).should_not be_valid
    end
  end

  describe ".update" do
    before(:each) {@post = FactoryGirl.build(:post)}

    it "should require title" do
      @post.title = ""
      @post.save.should be_false
    end

    it "should require body" do
      @post.body = ""
      @post.save.should be_false
    end

  end

  describe "#url" do
    it "should return post's url" do
      @post = FactoryGirl.build(:post)
      @post.url.should eq("/#{@post.id}/")
    end
  end

end

