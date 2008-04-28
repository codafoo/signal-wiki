require File.dirname(__FILE__) + '/../spec_helper'

describe LabeledPage do
  before(:each) do
    @labeled_page = LabeledPage.new
  end

  it "should be valid" do
    @labeled_page.should be_valid
  end
end
