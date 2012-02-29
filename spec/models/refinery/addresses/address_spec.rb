require 'spec_helper'

module Refinery
  module Addresses
    describe Address do
      describe "validations" do
        subject do
          FactoryGirl.create(:address,
          :first_name => "Refinery CMS")
        end

        it { should be_valid }
        its(:errors) { should be_empty }
        its(:first_name) { should == "Refinery CMS" }
      end
    end
  end
end
