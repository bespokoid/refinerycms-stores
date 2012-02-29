# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Products" do
    describe "Admin" do
      describe "products" do
        login_refinery_user

        describe "products list" do
          before(:each) do
            FactoryGirl.create(:product, :name => "UniqueTitleOne")
            FactoryGirl.create(:product, :name => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.products_admin_products_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before(:each) do
            visit refinery.products_admin_products_path

            click_link "Add New Product"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Name", :with => "This is a test of the first string field"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::Products::Product.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Name can't be blank")
              Refinery::Products::Product.count.should == 0
            end
          end

          context "duplicate" do
            before(:each) { FactoryGirl.create(:product, :name => "UniqueTitle") }

            it "should fail" do
              visit refinery.products_admin_products_path

              click_link "Add New Product"

              fill_in "Name", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::Products::Product.count.should == 1
            end
          end

        end

        describe "edit" do
          before(:each) { FactoryGirl.create(:product, :name => "A name") }

          it "should succeed" do
            visit refinery.products_admin_products_path

            within ".actions" do
              click_link "Edit this product"
            end

            fill_in "Name", :with => "A different name"
            click_button "Save"

            page.should have_content("'A different name' was successfully updated.")
            page.should have_no_content("A name")
          end
        end

        describe "destroy" do
          before(:each) { FactoryGirl.create(:product, :name => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.products_admin_products_path

            click_link "Remove this product forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Products::Product.count.should == 0
          end
        end

      end
    end
  end
end
