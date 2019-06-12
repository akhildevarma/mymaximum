def create_team_with_admin
  admin_email = "test.user@inpharmd.com"

  team = Team.seed do |t|
    t.id = 1
    t.name = "Test Team"
    t.email_domain = "inpharmd.com"
    t.admin_email = admin_email
    t.signup_url_path = "inpharmd"
    t.hidden = false
  end.first

  user = User.seed do |u|
    u.id    = 1
    u.email = admin_email
    u.password = "test1234"
    u.password_confirmation = "test1234"
    u.team = team
  end.first

  provider = Provider.new( user: user )
  administrator = Administrator.new( user: user )
  student = Student.new( user: user )
  profile = Profile.new( user: user, first_name: 'Admin', last_name: 'User', phone_number: '4041112233' )
  [ provider, administrator, student, profile ].each {|o| o.save( validate: false ) }

  return [team, user]
end

def create_team_users(team:, count:)
  team_users = count.times.each_with_object([]) do |i, output|
    id = User.last.id+1
    user = User.seed do |u|
      u.id = id
      u.email = Faker::Internet.email
      u.password = "test1234"
      u.password_confirmation = "test1234"
      u.team = team
    end.first
    provider = Provider.new( user: user ).save( validate: false )
    profile = Profile.new( user: user, first_name: Forgery(:name).first_name, last_name: Forgery(:name).last_name )
  end
end

def create_inquiries(user, *args)
  @questions = [
    "Are there incidences of seizures associated with poly B use?",
    "What is the association between ambien and sleepwalking/ sleeptalking/ etc?",
    "Which vaccines have been tested in pregnant patients?",
    "How much does clozaril affect WBC count? And what percent of patients does this affect?",
    "What are the risks of clonazepam taken concurrently with ambien?",
    "What is the association between statin use and tendon rupture?",
    "Which statin is most and least likely to cause muscle pain?",
    "Which statin is best with Harvoni?",
    "Do countries with socialized medicine have better/worse outcomes vs. countries without it?"
  ]
  inquiries = Inquiry.seed(:id,
    @questions.each_with_object([]).with_index do |(question, output),  index|
      output << {
        id: index,
        submitter: user,
        question: question,
        tag_list: ( 3.times.map { Forgery(:basic).text } ),
        review_of_clinical_guidelines: Faker::Lorem.paragraph,
        review_of_meta_analyses: %Q(
  After 6 days of continuing at 10 mg warfarin (if INR still not above 1.5), the following is recommended:
    Check INR on day 6:  For INR <1.5 give 7.5 - 12.5 mg
    Check INR on day 5:  For INR <1.5 give 10 mg
    Check INR on day 4:  For INR <1.5 give 10 mg
    Check INR on day 3:  For INR <1.5 give 5 - 10 mg [3]
        ),
        status: ( args.include?(:closed) ? 'complete' : 'review' ).to_sym,
        updated_at: ( rand(2..10).days.ago )
      }
    end
  )
  inquiries.each do |inquiry|
    SummaryTable.create(
      inquiry: inquiry,
      responder: user,
      body_html: '<table><tr><td>hey</td></tr></table>',
      references: "1. Reference\n2. Reference\n3. Reference\n4. Reference\n5. Reference\n6. Reference\n7. Reference\n "
    )
  end
end

def run
  team, admin_user = create_team_with_admin
  team_users = create_team_users(team: team, count: 10)
  inquiries = create_inquiries(admin_user)
  closed_inquiries = create_inquiries(admin_user, :closed)
end
run
