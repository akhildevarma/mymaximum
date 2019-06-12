class TwitterSharingsController < ApplicationController
  def create
    if params[:twitter_link]
      redirect_to I18n.t('share.' + params[:twitter_link])
    else
      redirect_to I18n.t('share.twitter_find_us_link')
    end
  end
end
