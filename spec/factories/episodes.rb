FactoryBot.define do
  sequence :episode_number

  factory :episode do
    watchable
    transient do
      epnum { generate(:episode_number) }
    end
    title { "QA Episode #{epnum}" }
    season_number 1
    episode_number { epnum }
  end
end