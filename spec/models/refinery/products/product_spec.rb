require 'spec_helper'

module Refinery
  module Products
    describe Product do
      describe "validations" do
        subject do
          FactoryGirl.create(:product,
          :name => "Refinery CMS")
        end

        it { should be_valid }
        its(:errors) { should be_empty }
        its(:name) { should == "Refinery CMS" }
      end
    end
  end
end
