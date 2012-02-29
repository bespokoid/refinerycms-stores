
FactoryGirl.define do
  factory :address, :class => Refinery::Addresses::Address do
    sequence(:first_name) { |n| "refinery#{n}" }
  end
end

