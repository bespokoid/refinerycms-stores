
FactoryGirl.define do
  factory :store, :class => Refinery::Stores::Store do
    sequence(:name) { |n| "refinery#{n}" }
  end
end

