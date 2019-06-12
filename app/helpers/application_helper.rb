module ApplicationHelper

  def bootstrap_class_for flash_type
    case flash_type.to_sym
      when :success
        "alert-success"
      when :error
        "alert-danger"
      when :alert
        "alert-warning"
      when :notice
        "alert-info"
      else
        flash_type.to_s
    end
  end


  def nav_link_class(path_prefix)
    'active' if path_prefix == controller.controller_name
  end

  def pretty_inquiry_price
    "#{number_to_currency(Product.inquiry.a_la_carte_price_in_dollars)} per inquiry"
  end

  def pretty_topic_search_price
    "#{number_to_currency(Product.topic_search.a_la_carte_price_in_dollars)} per search"
  end

  def us_states # TODO: surely there is a better way...?
    [
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CA'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Delaware', 'DE'],
      ['District of Columbia', 'DC'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Michigan', 'MI'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Puerto Rico', 'PR'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']
    ]
  end

  def specialties
    I18n.t("providers.specialties")
  end


  def available_teams
    Team.where(private_label: false).order(id: :asc).map {|team| {name: team.name, sign_up_url: team.signup_url_path, logo: team.logo.url(:medium), id: team.id} }
  end

  def human_boolean(boolean)
    boolean ? 'Yes' : 'No'
  end

  def average_time(time_array=[])
    if time_array.present?
      avg_time = (time_array.reduce(:+).to_f/time_array.size).round
      avg_time ? time_in_words(avg_time) : ''
    end
  end

  def minimum_time(time_array=[])
    if time_array.present?
      time_in_words(time_array.min)
    end
  end
  def maximum_time(time_array=[])
    if time_array.present?
      time_in_words(time_array.max)
    end
  end

  def time_in_words(time_in_mill)
    from_time = Time.now
    distance_of_time_in_words(from_time, from_time + time_in_mill)
  end

  def format_date(time=Time.now)
    time.strftime("%B %d, %Y")
  end

  def current_layout
    controller.send :_layout
  end

  def current_layout?(name)
    controller.send(:_layout).to_s == name.to_s
  end

  def comments_tree_for(comments, partial_path='comments/comment')
    comments.map do |comment, nested_comments|
      render(partial_path,
        comment: comment,
        reference: comment.reference,
        redirect_path: polymorphic_url(comment.reference),
        nested_comments: nested_comments ) +
          (nested_comments.size > 0 ? content_tag(:div, comments_tree_for(nested_comments,partial_path), class: "replies") : nil)
    end.join.html_safe
  end

  def footer_required?
    !authenticated?
  end

  def inquiry_document_sections(switch=nil, enable_discussion=false)
    logger.info "enable_discussion:;#{enable_discussion}"
    obj = {
      all: {
        title: 'All',
        object: nil,
        references: nil,
        default: user_preferences('inquiry_view_default_combined')
      },
      background: {
        title: 'Background',
        object: @inquiry.background,
        references: @inquiry.background_references,
        default: !user_preferences('inquiry_view_default_combined')
      },
      relevant_prescribing_info: {
        title: 'Relevant Prescribing Information',
        object: @inquiry.relevant_prescribing_info,
        references: @inquiry.relevant_prescribing_info_references,
      },
      literature_review: {
        title: 'Literature Review',
        object: @inquiry.summary_tables,
        inquiry: @inquiry,
        references: nil
      }
    }
    if enable_discussion && feature?(:discussion, inquiry: @inquiry)
      comments = @inquiry.active_comments(current_user)
      obj[:discussion] = {
        title: "Discussion" + ( i = comments.count; ( i > 0 ) ? " (#{i})" : "" ),
        object: comments,
        inquiry: @inquiry,
        references: nil
      }
    end
    case switch
    when :tabs
      obj.reject {|key ,section| section[:object].blank? && ![:all, :discussion].include?( key ) }
    when :content
      obj.reject {|key ,section| section[:object].blank? && ![:discussion].include?( key ) }
    else
      obj
    end
  end

  def include_section?(sections = {}, section = '')
    sections && sections[section].present?
  end

  def inquiry_due_time(inquiry)
    due_time = (inquiry.reopened_at || inquiry.created_at)
    if inquiry.turnaround_time!='asap'
      due_time + 1.day
    else
      due_time + 2.hours
    end
  end

  def unique_inquiry_url(inquiry)
    unique_url = (inquiry.slug || inquiry.try(:guid).try(:uid))
    unique_url ? guid_url(unique_url) : inquiry_url(inquiry.id)
  end

  def user_preferences(selector='')
    preferences = current_user.try(:preferences) || User::Preferences.default
    selector.present? ? (preferences.try selector.to_sym) : preferences
  end

  def inquiry_response_default_tab_index(enable_discussion=false)
    key = if user_preferences :inquiry_view_default_combined
      :all
    else
      :background
    end
    inquiry_document_sections(:tabs,enable_discussion).keys.find_index(key)
  end

  def greeting
    now = Time.now
    today = Date.today.to_time

    morning = today.beginning_of_day
    noon = today.noon
    evening = today.change( hour: 17 )
    night = today.change( hour: 20 )
    tomorrow = today.tomorrow

    if (morning..noon).cover? now
      I18n.t('greeting_morning')
    elsif (noon..evening).cover? now
      I18n.t('greeting_afternoon')
    elsif (((evening..night).cover? now )|| ((night..tomorrow).cover? now))
      I18n.t('greeting_evening')
    end
  end

end
