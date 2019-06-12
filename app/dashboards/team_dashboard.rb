require "administrate/base_dashboard"

class TeamDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    users: Field::HasMany,
    payment_account: Field::HasOne,
    user: Field::BelongsTo,
    id: Field::Number,
    payment_account_id: Field::Number,
    name: Field::String,
    active: Field::Boolean,
    admin_email: Field::String,
    signup_url_path: Field::String,
    email_domain: Field::String,
    logo: PaperclipField,
    hidden: Field::Boolean,
    kind: Field::Boolean
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    # :id,
    :name
    # :users,
    # :payment_account,
    # :user,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :users,
    # :payment_account,
    # :user,
    # :id,
    # :payment_account_id,
    :name,
    :active,
    :admin_email,
    :signup_url_path,
    :email_domain,
    :logo,
    :hidden,
    :kind
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    # :users,
    # :payment_account,
    # :user,
    # :payment_account_id,
    :name,
    :active,
    :admin_email,
    :signup_url_path,
    :email_domain,
    :logo,
    :hidden
  ].freeze

  # Overwrite this method to customize how teams are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(team)
    "#{team.name}"
  end
end
