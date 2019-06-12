class FacebookSharingsController < ApplicationController
  def create
    if params[:facebook_link]
      redirect_to I18n.t('share.' + params[:facebook_link])
    else
      redirect_to I18n.t('share.facebook_find_us_link')
    end
  end
end
