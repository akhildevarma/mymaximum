class PagesController < HighVoltage::PagesController
  layout :layout_for_page

  private

  def layout_for_page
    if params[:layout] == 'none'
      'mobile'
    else
      'marketing'
    end
  end
end
