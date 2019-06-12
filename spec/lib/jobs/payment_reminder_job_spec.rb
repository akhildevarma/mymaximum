require 'rails_helper'
describe PaymentReminderJob, :delayed_job do
  include RSpec::Rails::Matchers

  let(:job) { PaymentReminderJob.new(provider.id) }
  let(:team) { create :team, :with_5_members }

  describe '#perform' do

    context 'in team' do
      let(:provider) { team.users.first.provider }
      it { does_not_send_email }
    end


    context 'trailing' do
      let(:provider) { create(:provider_user).provider }
      it { sends_email }
    end

  end

  def sends_email
    expect {
      job.perform
    }.to have_enqueued_job.on_queue("mailers")
  end

  def does_not_send_email
    expect {
      job.perform
    }.to_not have_enqueued_job.on_queue("mailers")
  end

end
