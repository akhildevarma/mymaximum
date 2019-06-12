FactoryGirl.define do
  factory :inquiry do
    association :submitter, factory: :provider_user
    question { "Greetings from #{submitter.email}. This test question is about something very important!" }
    tag_list { 3.times.map { Forgery(:basic).text } }
    title { Faker::Lorem.sentence }
    view_everyone false

    trait :with_table do
      after :create do |inquiry|
        inquiry.summary_tables << SummaryTable.create(
          inquiry_id: inquiry.id,
          responder: FactoryGirl.create(:student_user),
          body_html: '<table><tr><td>hey</td></tr></table>',
          references: "1. Reference\n2. Reference\n3. Reference\n4. Reference\n5. Reference\n6. Reference\n7. Reference\n "
        )
      end
    end

    trait :completed do
      background { Faker::Lorem.paragraph }
      after :create do |inquiry|
        inquiry.send_response!
      end
    end

    trait :with_review do
      review_of_clinical_guidelines { Faker::Lorem.paragraph }
      review_of_meta_analyses { Faker::Lorem.paragraph }
      review_of_review_articles { Faker::Lorem.paragraph }
      review_of_other_tertiary_literature { Faker::Lorem.paragraph }
    end

    trait :with_assignee do
      association :assignee, factory: :student_user
    end

    trait :published do
      published_at ( Time.now - 1.day )
    end

    factory :inquiry_with_table, traits: [:with_table]
    factory :inquiry_with_reviews, traits: [:with_review]
    factory :inquiry_with_assignee, traits: [:with_assignee]
    factory :completed_inquiry, traits: [:with_table, :completed]
    factory :published_inquiry, traits: [:with_table, :completed, :published]
  end
end
