require 'rails_helper'

describe 'summary_tables/_form.html.erb' do
  before { set_student?(view)}
  context 'student user' do
    it 'does not include what happened to my formatting ' do
      user = FactoryGirl.build_stubbed(:student_user).decorate
      inquiry = FactoryGirl.create(:inquiry_with_table, status: :complete, submitter: user)
      summary_table = inquiry.summary_tables[0].decorate
      view.stub(:student?).and_return(user.student?)
      render partial: 'summary_tables/form', locals: { inquiry: inquiry, summary_table: summary_table }
      expect(rendered).to_not include(I18n.t("summary_tables.editor_tips_label"))
    end
  end

  context 'provider user' do
    it 'includes what happend to what happened to my formatting ' do
      user = FactoryGirl.build_stubbed(:provider_user).decorate
      inquiry = FactoryGirl.create(:inquiry_with_table, status: :complete, submitter: user)
      summary_table = inquiry.summary_tables[0].decorate
      view.stub(:student?).and_return(user.student?)
      render partial: 'summary_tables/form', locals: { inquiry: inquiry, summary_table: summary_table }
      expect(rendered).to include(I18n.t("summary_tables.editor_tips_label"))
    end
  end

  def set_student?(view)
    view.class.module_eval {
      define_method :student? do
        true
      end
    }
  end

end
