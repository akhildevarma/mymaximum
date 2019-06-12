require 'rails_helper'

describe BatchInvitationJob do
  let(:job) { BatchInvitationJob.new(100, true) }
  it 'gets the next n people on the given waitlist' do
    phony_scope = double('PhonyScope', find_each: true)
    expect(WaitlistedUser).to receive(:where).with(provider: true).and_return(phony_scope)
    expect(phony_scope).to receive(:next).with(100).and_return(phony_scope)
    expect(phony_scope).to receive(:each)
    job.perform
  end

  it 'creates an invitation for each waitlisted user' do
    WaitlistedUser.create(email: 'foo@bar.baz', provider: true)

    expect do
      job.perform
    end.to change { Invitation.count }.by(1)
    expect(Invitation.last.email).to eq('foo@bar.baz')
  end

  it 'removes an invited user from the waitlist' do
    WaitlistedUser.create(email: 'foo@bar.baz', provider: true)
    expect do
      job.perform
    end.to change { WaitlistedUser.count }.by(-1)
  end
end
