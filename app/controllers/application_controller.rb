class ApplicationController < ActionController::Base
  include Authentication

  before_filter :set_layout
  layout :get_layout

  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token, if: :json_request?

  before_filter :authenticate

  before_filter :account_activated?, unless: :json_request?
  before_filter :license_number_needed?, unless: :json_request?

  before_filter :set_team, unless: :json_request?

  rescue_from ::ActionController::RoutingError, with: :route_not_found

  def current_user
    if !cookies[:remember_me_token].blank?
      @current_user ||= User.find_by_remember_me_token!(cookies[:remember_me_token]).try :decorate
    else
      @current_user ||= User.find(session[:user_id]).try :decorate if !session[:user_id].nil?
    end
    @current_user.try :active!
    @current_user
  end

  # TODO: break out into library
  def feature?(name, **opts)
    @options = opts
    # Methods
    inquiry_is_published =  -> { @options[:inquiry] && @options[:inquiry].published? }
    user_is_comment_owner = -> { current_user && @options[:comment] && (@options[:comment].user_id == current_user.id) }

    can_compose_comment = -> do
      return false unless current_user
      profile = current_user.profile.try :decorate
      return false unless profile
      return false unless inquiry_is_published.call
      !!profile.first_name && profile.last_name
    end

    can_reply = -> { current_user && @options[:comment] && (1 + @options[:comment].depth < Comment::MAX_TREE_DEPTH) }
    comment_has_children = -> { @options[:nested_comments] && !@options[:nested_comments].empty? }
    comment_has_no_children = -> { @options[:nested_comments] && @options[:nested_comments].size.zero? }

    # Switch
    case name.to_sym
    when :news
      Inquiry.published.count >= 5
    when :discussion
      inquiry_is_published.call
    when :discussion_edit
      user_is_comment_owner.call
    when :discussion_delete
      user_is_comment_owner.call &&\
        comment_has_no_children.call
    when :discussion_flag
      !user_is_comment_owner.call
    when :discussion_reply
      can_compose_comment.call &&\
        can_reply.call
    when :discussion_composer
      can_compose_comment.call
    when :discussion_nested
      comment_has_children.call
    when :discussion_vote
        false # pending
    else
      false
    end
  end
  helper_method :feature?


  private

  def route_not_found
    respond_to do |format|
      format.html { render template: 'errors/404', status: 404 }
    end
  end


  def account_activated?
    return unless feature?(:account_activation)
    if authenticated?
      if current_user.requires_account_activation?
        session[:original_url] = request.original_url
        redirect_to new_account_activation_path
      end
    end
  end

  def credit_card_needs_update?
    if current_user.should_be_billed_for_inquiries?
      if current_user.payment_account.missing_credit_card?
        redirect_to edit_payment_account_path, flash: { error: I18n.t('errors.need_cc_info').html_safe }
      elsif !current_user.payment_account.account_not_delinquent?
        redirect_to edit_payment_account_path, flash: { error: I18n.t('errors.delinquent_account') }
      end
    end
  end

  def license_number_needed?
    if !admin? && provider? && !current_user.provider.valid?
      unless current_user.provider.errors[:license_number].blank?
        redirect_to edit_user_profile_path(current_user), flash: { error: I18n.t('errors.missing_license_number') }
      end
    end
  end

  def update_profile_info?
    return unless feature?(:force_profile_update)
    if provider? && (current_user.profile.nil? || !current_user.provider.valid?)
      session[:original_url] = request.original_url
      redirect_to edit_my_profile_path, flash: { error: I18n.t('errors.missing_profile_info') }
    end
  end

  def default_serializer_options
    { root: false }
  end

def force_logout
    @current_user = session[:user_id] = nil
  end

  def remove_session_original_url
    session[:original_url] = nil
  end


  protected

  def json_request?
    request.format.json?
  end

  def xhr_request?
     request.xhr? 
  end

  def errors_for(model_instance)
    raise 'Must inherit JsonErrorResource' unless model_instance.is_a? JsonErrorResource
    model_serializer_class_name = "::#{model_instance.class}ErrorSerializer"
    serializer_class = Object.const_defined?(model_serializer_class_name) ? model_serializer_class_name.constantize : ErrorSerializer
    serializer_class.new(model_instance)
  end

  def set_layout
    @layout = 'healthcare'
  end

  def get_layout
    @layout
  end

  def set_team
    if session[:team_name].present?
      @team = Team.find_by(signup_url_path: session[:team_name], private_label: true)
    end
  end


end
