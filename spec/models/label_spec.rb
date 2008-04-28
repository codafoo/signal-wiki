require File.dirname(__FILE__) + '/../spec_helper'

describe Label do
  before(:each) do
    @label = Label.new
  end

  it "should be valid" do
    @label.should be_valid
  end
end
