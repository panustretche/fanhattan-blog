require File.dirname(__FILE__) + '/spec_helper'
set :environment, :test

describe Comment do
  describe ".create" do

    it "should create a new instance given a valid attribute" do
      FactoryGirl.build(:comment).new_record?
    end

    it "should require title" do
      FactoryGirl.build(:comment, user: nil, body:"Lorem ipsum").should_not be_valid
    end

    it "should require body" do
      FactoryGirl.build(:comment, user: "Dave", body:nil).should_not be_valid
    end
  end

end


