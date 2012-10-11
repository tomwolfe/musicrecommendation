FactoryGirl.define do
  factory :track do
    sequence(:name) {|n| n.eql?(1) ? "Freebird" : "Freebird#{n}"}
    artist_name  "Lynard Skynard"
  end
end
