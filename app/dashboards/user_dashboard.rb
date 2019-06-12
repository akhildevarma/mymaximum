require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    administrator: Field::HasOne,
    student: Field::HasOne,
    provider: Field::HasOne,
    patient: Field::HasOne,
    profile: Field::HasOne,
    payment_account: Field::HasOne,
    team: Field::BelongsTo,
    comments: Field::HasMany,
    api_keys: Field::HasMany,
    invitation: Field::BelongsTo,
    survey_responses: Field::HasMany,
    submitted_inquiries: Field::HasMany.with_options(class_name: "Inquiry"),
    assigned_inquiries: Field::HasMany.with_options(class_name: "Inquiry"),
    interventions: Field::HasMany,
    topic_searches: Field::HasMany,
    user_emails: Field::HasMany,
    id: Field::Number,
    email: Field::String,
    password_digest: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    do_not_text: Field::Boolean,
    password_reset_token: Field::String,
    password_reset_sent_at: Field::DateTime,
    promo_code: Field::String,
    last_active_at: Field::DateTime,
    account_activated_at: Field::DateTime,
    account_activation_token: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :email,
    :team,
    :last_active_at
    # :administrator,
    # :student,
    # :provider,
    # :patient,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    # :administrator,
    # :student,
    # :provider,
    # :patient,
    # :profile,
    # :payment_account,
    :team,
    # :comments,
    # :api_keys,
    # :invitation,
    # :survey_responses,
    # :submitted_inquiries,
    # :assigned_inquiries,
    # :interventions,
    # :topic_searches,
    # :user_emails,
    # :id,
    :email,
    # :password_digest,
    :created_at,
    :updated_at,
    # :do_not_text,
    # :password_reset_token,
    # :password_reset_sent_at,
    # :promo_code,
    :last_active_at,
    # :account_activated_at,
    # :account_activation_token,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    # :administrator,
    # :student,
    # :provider,
    # :patient,
    # :profile,
    # :payment_account,
    :team,
    # :comments,
    # :api_keys,
    # :invitation,
    # :survey_responses,
    # :submitted_inquiries,
    # :assigned_inquiries,
    # :interventions,
    # :topic_searches,
    # :user_emails,
    # :email,
    # :password_digest,
    # :do_not_text,
    # :password_reset_token,
    # :password_reset_sent_at,
    # :promo_code,
    # :last_active_at,
    # :account_activated_at,
    # :account_activation_token,
  ].freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(user)
    "#{user.email}"
  end
end
