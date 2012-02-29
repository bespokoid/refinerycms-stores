# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Orders" do
    describe "Admin" do
      describe "orders" do
        login_refinery_user

        describe "orders list" do
          before(:each) do
            FactoryGirl.create(:order, :order_status => "UniqueTitleOne")
            FactoryGirl.create(:order, :order_status => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.orders_admin_orders_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before(:each) do
            visit refinery.orders_admin_orders_path

            click_link "Add New Order"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Order Status", :with => "This is a test of the first string field"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::Orders::Order.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Order Status can't be blank")
              Refinery::Orders::Order.count.should == 0
            end
          end

          context "duplicate" do
            before(:each) { FactoryGirl.create(:order, :order_status => "UniqueTitle") }

            it "should fail" do
              visit refinery.orders_admin_orders_path

              click_link "Add New Order"

              fill_in "Order Status", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::Orders::Order.count.should == 1
            end
          end

        end

        describe "edit" do
          before(:each) { FactoryGirl.create(:order, :order_status => "A order_status") }

          it "should succeed" do
            visit refinery.orders_admin_orders_path

            within ".actions" do
              click_link "Edit this order"
            end

            fill_in "Order Status", :with => "A different order_status"
            click_button "Save"

            page.should have_content("'A different order_status' was successfully updated.")
            page.should have_no_content("A order_status")
          end
        end

        describe "destroy" do
          before(:each) { FactoryGirl.create(:order, :order_status => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.orders_admin_orders_path

            click_link "Remove this order forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Orders::Order.count.should == 0
          end
        end

      end
    end
  end
end
