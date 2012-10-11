FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| n.eql?(1) ? "user@b.com" : "user#{n}@b.com"}
    password  "password"    
  end
end
