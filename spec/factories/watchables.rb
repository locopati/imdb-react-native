FactoryBot.define do
  factory :watchable do
    sequence :title do |n| "QA Watchable #{n}" end
  end
end