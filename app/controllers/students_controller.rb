class StudentsController < ApplicationController
  before_filter :authenticate_student
  before_filter :find_student

  respond_to :json

  def update
    if @student.update(student_params)
      respond_with @student
    else
      respond_with @student
    end
  end

  private

  def authenticate_student
    unless student?
      render file: File.join(Rails.root, 'public/403.html'), status: 403, layout: false
    end
  end

  def find_student
    @student = current_user.student
  end

  def student_params
    params.require(:student).permit(:is_active)
  end
end
