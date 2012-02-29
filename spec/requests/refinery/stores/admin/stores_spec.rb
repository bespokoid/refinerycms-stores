# encoding: utf-8
require "spec_helper"

describe Refinery do
  describe "Stores" do
    describe "Admin" do
      describe "stores" do
        login_refinery_user

        describe "stores list" do
          before(:each) do
            FactoryGirl.create(:store, :name => "UniqueTitleOne")
            FactoryGirl.create(:store, :name => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.stores_admin_stores_path
            page.should have_content("UniqueTitleOne")
            page.should have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before(:each) do
            visit refinery.stores_admin_stores_path

            click_link "Add New Store"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Name", :with => "This is a test of the first string field"
              click_button "Save"

              page.should have_content("'This is a test of the first string field' was successfully added.")
              Refinery::Stores::Store.count.should == 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              page.should have_content("Name can't be blank")
              Refinery::Stores::Store.count.should == 0
            end
          end

          context "duplicate" do
            before(:each) { FactoryGirl.create(:store, :name => "UniqueTitle") }

            it "should fail" do
              visit refinery.stores_admin_stores_path

              click_link "Add New Store"

              fill_in "Name", :with => "UniqueTitle"
              click_button "Save"

              page.should have_content("There were problems")
              Refinery::Stores::Store.count.should == 1
            end
          end

        end

        describe "edit" do
          before(:each) { FactoryGirl.create(:store, :name => "A name") }

          it "should succeed" do
            visit refinery.stores_admin_stores_path

            within ".actions" do
              click_link "Edit this store"
            end

            fill_in "Name", :with => "A different name"
            click_button "Save"

            page.should have_content("'A different name' was successfully updated.")
            page.should have_no_content("A name")
          end
        end

        describe "destroy" do
          before(:each) { FactoryGirl.create(:store, :name => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.stores_admin_stores_path

            click_link "Remove this store forever"

            page.should have_content("'UniqueTitleOne' was successfully removed.")
            Refinery::Stores::Store.count.should == 0
          end
        end

      end
    end
  end
end
