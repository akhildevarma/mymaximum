class SignupsController < ApplicationController
  def new
    redirect_to team_provider_signup_path
  end
end
