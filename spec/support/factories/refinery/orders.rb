
FactoryGirl.define do
  factory :order, :class => Refinery::Orders::Order do
    sequence(:order_status) { |n| "refinery#{n}" }
  end
end

