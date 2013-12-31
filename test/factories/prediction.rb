FactoryGirl.define do
  factory :prediction do
    value '1'
    rating
  end
  factory :nil_prediction, class: Prediction do
    rating
  end 
end
