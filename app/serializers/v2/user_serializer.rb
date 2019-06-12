module V2
  class UserSerializer < ActiveModel::Serializer
  	attributes :email,
      :is_admin,
      :created_at,
      :updated_at,
      :do_not_text,
      :team_id,
      :is_active,
      :last_active_at,
      :account_activated_at

    def is_admin
      object.administrator?
    end

    def do_not_text
      object.do_not_text || ''
    end

    def team_id
      object.team_id || ''
    end

    def last_active_at
      object.last_active_at || ''
    end

    def account_activated_at
      object.account_activated_at || ''
    end

  end
end
