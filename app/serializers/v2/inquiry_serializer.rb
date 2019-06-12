  module V2
  class InquirySerializer < ActiveModel::Serializer
    attributes :id,
      :submitter_id,
      :assignee_id,
      :created_at,
      :turnaround_time,
      :status,
      :question,
      :title,
      :researchable_question,
      :read_at,
      :intervention_response,
      :custom_response_text,
      :search_strategy,
      :background,
      :prescribing_information,
      :is_unread,
      :view_everyone,
      :summary_tables,
      :hidden_sections,
      :level_of_evidence,
      :submitter_team,
      :dic_center_details,
      :project_types,
      :documents

    def created_at
      object.created_at.to_i
    end

    def project_types
      object.project_types ? object.project_types.text : ''
    end

    def documents
      if object.documents.present?
        object.documents
      end
    end

    def read_at
      object.read_at.try :to_i
    end

    def status
      object.status == 'research' ? 'literature_search' : object.status
    end

    def background
      {
        body: object.background,
        references: object.background_references
      }
    end

    def prescribing_information
      {
        prescriptions: object.relevant_prescribing_info,
        references: object.relevant_prescribing_info_references
      }
    end

    def submitter_team
      if team = object.submitter.try(:team)
        {
          name: team.name,
          logo_url_small:  team.try(:logo).url(:small),
          logo_url_medium:  team.try(:logo).url(:medium)
        }
      end
    end

    def summary_tables
      summary_tables = []
      object.summary_tables.each do |st|
        table_hash = {}
        table_hash[:formatted] = st.body_html unless ['unformatted'].include? @instance_options[:table_format]
        table_hash[:unformatted] = st.data if ['unformatted', 'both'].include? @instance_options[:table_format]
        summary_tables << {
          table: table_hash,
          references: st.references
        }
      end
      summary_tables
    end
  end
end
