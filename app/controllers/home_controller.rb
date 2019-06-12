class HomeController < HealthcareController
  skip_filter :set_referer
  before_filter :require_user, only: [:index]

  def index
    unless provider? || admin?
      redirect_to page_path('our_story')
    end
    if (current_user.private_labeled_user? && current_user.team_admin?)
      redirect_to members_custom_admin_team_path(current_user.team)
    end
    @inquiry = Inquiry.new
    @asked_by_me = Inquiry.asked_by_me(current_user).decorate
    @unread_by_me = Inquiry.unread_for_user(current_user)
    @news = Inquiry.published
  end

end
