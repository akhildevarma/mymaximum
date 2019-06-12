require 'rails_helper'

describe Users::TeamSignupsController do
  let(:team) { create :team }
  let!(:example_attributes) {
    {
        user: { email: "mr.user@#{team.email_domain}", password: 'password', password_confirmation: 'password' },
        email_username: 'mr.user',
        accept_team_of_service_and_privacy_policy: 0
    }
  }
  let(:params_hash) { { user_team_signup: example_attributes } }
  let(:params){ ActionController::Parameters.new(params_hash) }
  let!(:controller_instance) { Users::TeamSignupsController.new }

  it 'allows expected attributes' do
    safe_params = Users::TeamSignupsController::SafeParams.build(params)
    expect(safe_params).to eq(example_attributes.with_indifferent_access)
  end

  describe '#new' do
    before { get :new, signup_url_path: team.signup_url_path }
    it { expect(assigns(:team_signup).team).to eq team }
  end

  describe '#create' do
    context 'with email_username' do
      before do
        # create team signup with email_username
        post :create, signup_url_path: team.signup_url_path, user_team_signup: { email_username: 'mike.dundas' }
      end
      it { expect(assigns(:team_signup).email?).to be true }
      it { is_expected.to render_template 'create' }
    end
    context 'without email_username' do
      before { post :create, signup_url_path: team.signup_url_path }
      it { is_expected.to render_template :new }
    end
    context 'with password' do
      before { post :create, params_hash.merge(signup_url_path: team.signup_url_path)  }
      it { expect(User.last.email).to eq params_hash[:user_team_signup][:user][:email]}
      it { expect(session[:user_id]).to eq User.last.id}
      it { is_expected.to redirect_to root_path }
    end
  end

  describe '#set_team_signup' do
    before do
      allow(controller_instance).to receive(:params).and_return( params.merge({ signup_url_path: team.signup_url_path }))
    end
    subject { controller_instance.set_team_signup.team }
    it { is_expected.to eq team }
  end

  describe '#check_team_path' do
    let(:signup_url_path) { team.signup_url_path }
    let(:signup_url_path_param) { signup_url_path }
    before do
      allow(controller_instance).to receive(:params).and_return( params.merge({ signup_url_path: signup_url_path_param  }))
    end
    subject { controller_instance.send :check_team_path }
    it { expect { subject }.to_not raise_error }
    context 'capitalized signup path' do
      let(:signup_url_path_param) { signup_url_path.capitalize }
      it { expect { subject }.to_not raise_error }
    end
  end

end
