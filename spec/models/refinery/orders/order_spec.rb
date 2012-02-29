require 'spec_helper'

module Refinery
  module Orders
    describe Order do
      describe "validations" do
        subject do
          FactoryGirl.create(:order,
          :order_status => "Refinery CMS")
        end

        it { should be_valid }
        its(:errors) { should be_empty }
        its(:order_status) { should == "Refinery CMS" }
      end
    end
  end
end
