class CustomAdmin::StudentsController < CustomAdmin::ApplicationController
  before_filter :find_student, except: [:index]

  def index
    @students = StudentDecorator.decorate_collection(Student.all.order(:id))
  end

  def show
    @student = StudentDecorator.decorate(@student)
  end

  def update
    if @student.update(student_params)
      redirect_to custom_admin_students_path
    else
      flash.now.alert = I18n.t('errors.generic')
      render 'edit'
    end
  end

  private

  def find_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:can_assign, :is_alumn)
  end
end
