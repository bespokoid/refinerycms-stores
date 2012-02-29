
FactoryGirl.define do
  factory :product, :class => Refinery::Products::Product do
    sequence(:name) { |n| "refinery#{n}" }
  end
end

