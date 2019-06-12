class Team < ActiveRecord::Base
  KINDS = [
    'hospital',
    'organization'
  ]

  # Paperclip Image Attachment
  has_attached_file :logo, styles: {
    thumb: '50x50>',
    small: '100x100>',
    medium: '300x300>'
  }, processors: lambda { |instance| instance.logo_processors }
  attr_accessor :crop_x, :crop_y, :crop_width, :crop_height

  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

  before_update :logo_reprocess, if: :cropping?

  has_many :users
  has_one :payment_account, dependent: :destroy
  belongs_to :user
  has_many :documents,->{ where('file_file_name is not NULL and referenceable_type = ?', 'Team').order(created_at: :desc)}, class_name: 'Document',foreign_key: 'referenceable_id'

  alias :admin :user

  SIGNUP_URL_PATH_MATCHER = /\A([a-z]+[\-]?)+[a-z]\Z/

  validates :name, uniqueness: true, presence: true
  validates :admin_email, presence: true, format: /([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})/
  validates :email_domain, presence: true, format: /[\w\d]+(\.[\w\d]+)+/
  validates :signup_url_path, uniqueness: true, presence: true, format: Team::SIGNUP_URL_PATH_MATCHER
  validates :kind, :inclusion => { :in => Team::KINDS }, :allow_nil => true

  def self.with_signup_flow
    @relation = self.where( { active: true, hidden: false,  private_label: false } ).order(launch_date: :asc)
    [:name, :admin_email, :email_domain, :signup_url_path].each do |attr|
      @relation = @relation.where("#{attr} IS NOT NULL")
    end
    @relation
  end

  def not_hidden
    !hidden
  end

  def self.search_users(search, team)
    return team.users  unless search.present?
    User.joins(:profile).where('users.team_id = :team_id AND (profiles.first_name ILIKE :search OR profiles.last_name ILIKE :search OR profiles.phone_number ILIKE :search OR users.email ILIKE :search)', search: "%#{search}%", team_id: team.id)
  end

  def team_admin_user
    user || User.find_by(email: admin_email)
  end

  def can_be_updated_by?(resource)
    active && not_hidden
  end

  def signup_flow_active?
    (active && not_hidden) &&\
    [:name, :admin_email, :email_domain, :signup_url_path].map { |attr| !!send(attr) }.all?
  end

  def capitalized_name
    name.gsub(/\w+/, &:capitalize) rescue nil
  end

  def team_admin_name
    team_admin_user.try(:decorate).try(:name)
  end

  def self.search(query)
    if query.present?
        Team.with_signup_flow.
          where("(lower(name) like ?)  or (lower(signup_url_path) like ?) and private_label = false ", "%#{query.downcase}%", "%#{query.downcase}%")
    end
  end

  def cropping?
    [crop_x, crop_y, crop_width, crop_height].all? { |attr| attr.present? }
  end

  def logo_reprocess
   logo.assign(logo)
   logo.save
  end

  def cropping_attributes
    [:crop_x, :crop_y, :crop_width, :crop_height].map &:to_s
  end

  def logo_processors
    logo_processors = [:thumbnail]
    if cropping?
      logo_processors.unshift :manual_crop
    end
    return logo_processors
  end

end
