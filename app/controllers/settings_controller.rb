class SettingsController < ApplicationController
	def unsubscribe
	  @user = User.find_by_email(params[:email])
	  @group = EmailList.find_by_group(params[:group])
	  @unscribe_list = UnscriberList.new
	end

	def update
	  @unscribe = UnscriberList.new(unscriber_params)
	  if @unscribe.save
	    flash[:notice] = 'Subscription Cancelled' 
	    redirect_to root_url
	  else
	    flash[:alert] = 'There was a problem'
	    render :unsubscribe
	  end
	end

	def unscriber_params
		params.require(:unscriber_list).permit(:email, :group_id)
	end
end
