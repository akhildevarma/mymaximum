require 'rails_helper'

describe SurveyProcessor do
  let(:user) { FactoryGirl.build(:user_with_profile, do_not_text: false) }
  let(:twilio_messages_client) { double('twilio_messages_client') }
  before :each do
    allow(Profile).to receive(:where) { [user.profile] }
    allow_any_instance_of(SurveyProcessor).to receive(:twilio_messages_client) { twilio_messages_client }
  end
  it 'does not send an SMS to a user who does not want to receive texts' do
    user.do_not_text = true

    survey_processor = SurveyProcessor.new(user_id: user.id)
    expect(twilio_messages_client).not_to receive(:create)

    survey_processor.start_initial_survey
  end

  it 'sends an SMS prompting a user to take a survey' do
    survey_processor = SurveyProcessor.new(user_id: user.id)

    expect(twilio_messages_client).to receive(:create).with(hash_including(to: "+1#{user.profile.phone_number}")).at_least(:once)

    survey_processor.start_initial_survey
  end

  it 'looks up users by phone number' do
    survey_processor = SurveyProcessor.new(phone_number: user.profile.phone_number)
    expect(survey_processor.instance_variable_get(:@user)).to eq(user)
  end

  context 'with a new survey', :ignore do
    let(:survey_response) { stub_model(SurveyResponse, new?: true, complete?: false) }
    before do
      allow(user).to receive(:initial_survey_response) { survey_response }
    end
    it 'begins a new survey' do
      expect(survey_response).to receive(:begin!).and_return(true)

      survey_processor = SurveyProcessor.new(user_id: user.id)
      survey_processor.respond('foo bar')
    end
  end

  context 'with an in-progress survey' do
    let(:survey_response) { stub_model(SurveyResponse, new?: false, complete?: false) }
    before do
      allow(user).to receive(:initial_survey_response) { survey_response }
    end

    it "records a user's response to a survey question" do
      expect(survey_response).to receive(:record_answer).with('foo bar').and_return(true)

      survey_processor = SurveyProcessor.new(user_id: user.id)
      survey_processor.respond('foo bar')
    end

    it 'permanently stops sending a user text messages if they respond STOP' do
      survey_processor = SurveyProcessor.new(user_id: user.id)
      expect do
        survey_processor.respond('STOP')
      end.to change { user.do_not_text }.to(true)
    end
  end
  context 'when run async with a decorated user object', :delayed_job do
    let(:worker) { worker = Delayed::Worker.new }
    let(:user) { FactoryGirl.build(:user_with_profile, do_not_text: nil) }
    context 'user_id' do
      let(:survey_processor) { SurveyProcessor.new(user_id: user.id) }
      it { is_expected_to_complete_job }
    end
    context 'phone_number' do
      let(:survey_processor) { SurveyProcessor.new(phone_number: user.decorate.phone_number ) }
      it { is_expected_to_complete_job }
    end

    def is_expected_to_complete_job
      expect do
        survey_processor.start_initial_survey
      end.to change { Delayed::Job.count }.to(1)
      expect do
        worker.run Delayed::Job.first
      end.to change { Delayed::Job.count }.to(0)
    end


  end
end
