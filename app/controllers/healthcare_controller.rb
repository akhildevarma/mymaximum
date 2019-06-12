class HealthcareController < ApplicationController

  def set_layout
    @layout = 'healthcare'
  end

  def user_profile_params
    params.require(:user_profile)
      .permit(profile: [:first_name, :middle_name,
                        :last_name, :name_suffix,
                        :name_title, :company,
                        :city, :state, :phone_number],
                  provider: [:license_number, :licensing_state,
                             :specialty],
                  user: [:email,:password, :password_confirmation],
                  user_email: [:id, :email, :is_primary]
                  )
  end
end
