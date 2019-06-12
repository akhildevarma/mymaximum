MercerInpharmd::Application.routes.draw do

  get '/*id' => 'pages#show', :as => :page, :format => false, :constraints => HighVoltage::Constraints::RootRoute


  mount API => '/api'
  mount GrapeSwaggerRails::Engine => '/apidoc', as: 'apidoc'

  root to: 'home#index'

  match '/delayed_job' => DelayedJobWeb, :anchor => false, via: [:get, :post]

  class IsNotJson
    def self.matches?(request)
      request.format != :json
    end
  end

  # Rails Front-end
  scope constraints: IsNotJson do

    get 'login' => 'sessions#new', :as => 'login'
    get 'signup' => 'signups#new', :as => 'signup'

    # Administrate by Thoughtbot
    namespace :admin do
      resources :users
      resources :teams
      root to: "users#index"
    end

    # Custom Admin section
    namespace :custom_admin do
      resources :news, only: [:index] do
        get :publish, on: :member
        get :remove, on: :member
      end
      resources :users, only: [:index, :show, :destroy]
      resources :inquiries, only: [:index]
      resources :students, only: [:index, :show, :update]
      resources :teams, except: [:edit, :destroy] do
        get :members, on: :member
        get :team_inquiries, on: :member
        get :resend_invite, on: :member
        get :change_team_admin, on: :member
        get :make_team_admin, on: :member
        delete :remove_from_team, on: :member
      end
      resources :dashboard, only: [:index]
      resources :mailchimp, only: [:index]
      post '/mailchimp/send/:campaign_id', to: 'mailchimp#send_campaign', as: :mailchimp_send
      resources :upload_users, only: [:edit, :update]
      resources :comments, only: [:index,:edit, :update]
      resources :flagged_comments, only: [:index,:edit, :update,:destroy]
      get '/downloads/:id', to: 'downloads#show', as: :downloads
    end

    get '/mme_calculator' => 'custom_admin/mme_calculator#index', as: 'mme_calculator'
    get '/flagged_comments/users/:comment_id', to: 'custom_admin/flagged_comments#users', as: :flagged_comment_users
    post '/add_team_user' => 'custom_admin/teams#add_user', as: 'add_team_user'
    post '/upload_team_users' => 'custom_admin/upload_users#import', as: 'upload_team_users'
    get '/uploaded_users/:team_id' => 'custom_admin/upload_users#index', as: 'uploaded_users'
    get '/drug_shortage' => 'custom_admin/drug_shortage#index', as: 'drug_shortages'
    get '/drug_shortage/reload' => 'custom_admin/drug_shortage#reload', as: 'drug_shortages_refresh'
    post '/drug_upload' => 'custom_admin/drug_shortage#upload', as: 'drug_upload'

    resource :session, only: [:new, :create, :destroy]
    resource :password_reset, except: [:index, :show, :destroy]

    resource :waitlisted_provider, only: [:new, :create]
    resource :waitlisted_patient, only: [:new, :create]

    resource :batch_invitation, only: [:new, :create]
    resource :invitation, only: [:new, :create]

    resource :student_signup, only: [:new, :create]
    resource :provider_signup, only: [:new, :create] do
      get :team, on: :member
      post :sign_up_tracker, on: :member
    end
    resources :comments, only: [:create, :update, :destroy] do
      put 'flag', on: :member
    end

    resources :documents, only: [:create, :update, :destroy, :show]
    resources :blog_images, only: [:create, :update, :destroy, :show]
    resources :provider_plans, only: [:index]

    resources :my_inquiries, only: [:index, :new, :create] do
      member do
        get 'summary_tables'
      end
    end
    resources :inquiries, only: [:index, :edit, :update, :show] do
      collection do
        get 'closed'
      end
      member do
        get 'review'
        post 'send_response'
        put 're_open'
        put 'rating'
        put 'add_doc'
        get 'rating'
        get 'thanks_rating'
        get 'write_blog'
        get 'chat'
        post 'auto_save'
        post 'level_of_evidence'
      end
      resource :inquiry_assignment, only: [:create, :destroy], path: 'assignment', as: 'assignment'
      resources :summary_tables, except: [:index] do
        post 'auto_save', on: :member
      end
      resources :related_inquiries, path: 'related'
    end
    resource :inquiry_copy, only: :create

    resources :interventions, only: :create

    get 'summary_table_template', to: 'summary_tables#template'
    post 'summary_tables_auto_save/:inquiry_id/(:id)', to: 'summary_tables#auto_save', as: 'summary_tables_auto_save'

    # resources :topic_searches, only: [:index, :new, :create, :show] do
    #   get 'tags', on: :member
    # end

    resources :user_profiles, only: [:show, :edit, :update]
    resource :my_profile, only: [:edit, :update] do
      delete 'deactivate', on: :member
      post 'join_discussion', on: :member
    end
    resource :payment_account, only: [:show, :edit, :update]
    resources :students, only: [:update]

    resources :survey_responses, only: :index

    resources :twilio_sms_responses, only: :create

    resources :facebook_sharings, only: :create
    resources :twitter_sharings, only: :create

    get 'news', to: 'news#index', as: 'news'
    get 'docs_view/:resource_id/:resource_type', to: 'documents#show', as: 'docs_view'
    get 'uploader/:resource_id/:resource_type', to: 'documents#uploader', as: 'docs_uploader'
    post 'upload/:resource_id/:resource_type', to: 'documents#upload', as: 'docs_upload'
    get 'docs/view/:token', to: 'documents#download', as: 'docs_download'
    get 'image_uploader/:resource_id/:resource_type', to: 'blog_images#uploader', as: 'blog_images_uploader'
    post 'image_upload/:resource_id/:resource_type', to: 'blog_images#upload', as: 'blog_images_upload'
  
    resource :application_settings, only: [:show, :edit, :update]


    get '/activate_account' => 'account_activations#new', as: 'new_account_activation'
    get '/activate_account/:token' => 'account_activations#show', as: 'account_activation'
    get '/email_activation/:token' => 'account_activations#email_activation', as: 'email_activation'

    # glorified URL shortening-- semantically these should be POSTs, but since they'll
    # be sent via SMS as plaintext URLs, we need them to respond to GETs.
    get 'fb' => 'facebook_sharings#create'
    get 'tw' => 'twitter_sharings#create'
    get 'settings/unsubscribe'
    post 'settings/update'

    class InquiryMatcher
      def self.matches?(request)
        guid_url_path = request.path.split('/')[1]
        return false unless !!(guid_url_path =~ /[\w.-]+/)
        guid = Inquiry.where('lower(slug) = ?', guid_url_path.downcase).first || Guid.where('lower(uid) = ?', guid_url_path.downcase).first
        guid.present?
      end
    end

    get '/:guid' => 'inquiries#show', as: 'guid', constraints: InquiryMatcher
    get '/write_blog' => 'inquiries#write_blog', as: 'write_blog'
    class TeamSignupMatcher
      def self.matches?(request)
        team_signup_url_path = request.path.split('/')[1]
        return false unless !!(team_signup_url_path =~ Team::SIGNUP_URL_PATH_MATCHER)
        team = Team.where('lower(signup_url_path) = ?', team_signup_url_path.downcase).first
        return false unless team
        team && team.signup_flow_active?
      end
    end

    constraints(TeamSignupMatcher) do
      get '/:signup_url_path/:token' => 'users/team_signups#add', as: 'add_team_user_signups'
      get '/:signup_url_path' => 'users/team_signups#new'
      post '/:signup_url_path' => 'users/team_signups#create', as: 'user_team_signups'
    end

    post '/edit/:signup_url_path' => 'users/team_signups#edit', as: 'edit_user_team_signups'

    if Rails.env.development?
      mount LetterOpenerWeb::Engine, at: '/letter_opener'
    end

    # Rails Mailer Preview
    get '/rails/mailers'         => "rails/mailers#index"
    get '/rails/mailers/*path'   => "rails/mailers#preview"


  end

  class IsJsonRequest
    def self.matches?(request)
      request.format == :json
    end
  end

  def legacy_routes
    resource :application_settings, only: [:show]
    resources :my_inquiries, only: [:index, :new, :create] do
      member do
        get 'summary_tables'
      end
    end
    resource :my_profile, only: [:show, :update, :destroy]
    resource :password_reset, only: :create
    resource :provider_signup, only: :create
    resource :patient_signup, only: :create
    resource :waitlisted_patient, only: :create
    resource :waitlisted_provider, only: :create
    resource :password_reset, only: :create
    resource :session, only: [:create, :destroy]
    # resources :topic_searches, only: [:index, :create, :show] do
    #   get 'tags', on: :member
    #   resource :topic_search_job_status, only: :show, path: 'job_status', as: 'job_status'
    #   scope module: 'topic_searches' do
    #     resource :medline_plus_result, only: :show
    #     resource :guideline_gov_result, only: :show
    #     resource :daily_med_result, only: :show
    #     resource :fda_result, only: :show
    #   end
    # end
    resource :payment_account, only: [:show, :update]
    resource :inquiry_tags, only: [:show, :create, :destroy]
  end

  # API: Legacy
  scope module: 'api/legacy', constraints: IsJsonRequest do
    legacy_routes
  end

  # API v1
  namespace :api, defaults: { format: 'json' } do
    namespace :legacy do
      legacy_routes
    end
    namespace :v1 do
      resource :provider_signup, only: :create
      resources :inquiries, only: [:show]
      resources :comments, only: [:update, :destroy] do
        put 'flag', on: :member
        # put 'update', on: :member
        # delete 'destroy', on: :member
      end
      put '/user/preferences' => 'user/preferences#update', as: 'user_preferences'
      get '/admin/teams/:team_id/user_upload/processing' => 'admin/teams/user_upload#processing', as: 'admin_teams_user_upload_processing'
    end

  end

end
