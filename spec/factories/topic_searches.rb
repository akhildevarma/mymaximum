FactoryGirl.define do
  factory :topic_search do
    search_terms { Forgery(:basic).text }

    trait :skip_jobs do
      after :build do |topic_search|
        topic_search.stub(:start_queries).and_return(true)
      end
    end

    factory :topic_search_skipping_jobs, traits: [:skip_jobs]
  end
end
