class NewsController < CustomAdmin::ApplicationController
  skip_before_filter :authenticate_admin
  before_filter :require_student_provider

  def index
    @news = Inquiry.public_inquiries
    @comment = Comment.new
  end
end
