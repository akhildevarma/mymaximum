module SessionHelper
  module Features
    def login_as_student
      student = FactoryGirl.create(:student_user)
      login(student)
      student
    end

    def login_as_admin
      admin = FactoryGirl.create(:admin_user)
      login(admin)
      admin
    end

    def login_as_provider
      @provider = FactoryGirl.create(:provider_user)
      login(@provider)
      @provider
    end

    def login_as_empty_provider
      @provider = FactoryGirl.create(:empty_provider_user)
      login(@provider)
      @provider
    end

    def login_as_patient
      patient = FactoryGirl.create(:patient_user)
      login(patient)
      patient
    end

    def login(user)
      Capybara.reset_session!
      visit login_path
      fill_login_form_with(email: user.email, password: user.password)
    end

    def fill_login_form_with(email:, password:)
      first('input[name="email"]', visible: true).set(email)
      first('input[name="password"]', visible: true).set(password)
      click_on 'Login'
    end

  end

  module Controllers
    def login_as_admin
      admin = FactoryGirl.create(:admin_user)
      login(admin)
      admin
    end

    def login_as_provider
      provider = FactoryGirl.create(:provider_user)
      login(provider)
      provider
    end

    def login(user)
      request.session[:user_id] = user.id
    end

    def logout
      request.session[:user_id] = nil
    end

    def login_as_student
      student = FactoryGirl.create(:student_user)
      login(student)
      student
    end
  end

  module Requests
    def login_as_provider
      provider = FactoryGirl.create(:provider_user)
      login(provider)
      provider
    end

    def login_as_student
      student = FactoryGirl.create(:student_user)
      login(student)
      student
    end

    def login_as_patient
      patient = FactoryGirl.create(:patient_user)
      login(patient)
      patient
    end

    def login_as_admin
      admin = FactoryGirl.create(:admin_user)
      login(admin)
      admin
    end

    def login_with_token(user)
      post '/api/v2/login', { email: user.email, password: user.password}, {}
      env['X-Access-Token'] = JSON.parse(response.body)['data']['attributes']['access-token']
    end

    def login_as_provider_with_token
      provider = FactoryGirl.create(:provider_user)
      login_with_token(provider)
      provider
    end

    def env
      @env ||= {}
    end

    def login(user)
      env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.email, user.password)
    end
  end
end
