class CustomAdmin::DashboardController < CustomAdmin::ApplicationController
  def index
    @charts = {
      new_users_by_month: User.new_by_month,
      last_active_by_month: User.last_active_by_month,
      new_inquiries_by_month: Inquiry.new_by_month
    }

    @inquiry = {
      total: Inquiry.count,
      new_today: Inquiry.new_today.count,
      recent: Inquiry.order(created_at: :desc).limit(5),
      per_user_last_30: Inquiry.per_user_last_30,
      per_team_last_30: Inquiry.per_team_last_30,
      last_week_asap: Inquiry.last_inquiries_by_timeframe(7,1),
      last_month_asap: Inquiry.last_inquiries_by_timeframe(30,1),
      last_year_asap: Inquiry.last_inquiries_by_timeframe(365,1),
      last_week_all: Inquiry.last_all_inquiries_except_asap(7),
      last_month_all: Inquiry.last_all_inquiries_except_asap(30),
      last_year_all: Inquiry.last_all_inquiries_except_asap(365)

    }
    @student = {
      per_student: inquiries_per_student
    }

    @percentages = {
      last_week_asap: calculate_inquiry_percentage(1,2.hours,7),
      last_month_asap: calculate_inquiry_percentage(1,2.hours,30),
      last_year_asap: calculate_inquiry_percentage(1,2.hours,365),
      last_week_one_day: calculate_inquiry_percentage(2,2.days,7),
      last_month_one_day: calculate_inquiry_percentage(2,2.days,30),
      last_year_one_day: calculate_inquiry_percentage(2,2.days,365),
      last_week_a_few_days: calculate_inquiry_percentage(3,3.days,7),
      last_month_a_few_days: calculate_inquiry_percentage(3,3.days,30),
      last_year_a_few_days: calculate_inquiry_percentage(3,3.days,365),
      last_week_a_week: calculate_inquiry_percentage(4,7.days,7),
      last_month_a_week: calculate_inquiry_percentage(4,7.days,30),
      last_year_a_week: calculate_inquiry_percentage(4,7.days,365)
    }
    @topic_search = {
      total: TopicSearch.count,
      recent: TopicSearch.order(created_at: :desc).limit(5)
    }
    @users = {
      active_today: User.active_today.count,
      total: User.count,
      active_last_30: User.active_last_30.count,
      by_inquiries_count: User.by_inquiries_count,
      active_last_week: User.active_last_week.count,
      registered_last_week: User.registered_last_week.count
    }
  end

  private
    def inquiries_per_student
      all_completed_inquires = Inquiry.all_completed_inquiries
      questions = Hash.new("")
      result = all_completed_inquires.inject(Hash.new(0)) { |result,item|
        user = User.find_by( id: item[:version].inquiry_assignee_id );
        if user.present?
          result[user.email] += 1;
          questions[user.email] += (item[:inquiry].question << "#$#");
        end;
        result
      }
      {count: result, questions: questions}
    end

    def calculate_inquiry_percentage(turnarround,period,timeframe)
       all_completed_inquires = Inquiry.completed_inquiries_by_turnarround(timeframe,turnarround)
       completed_inquiries = Hash.new(0)
       all_completed_inquires.each { |inq|
        completed_inquiries[:success] +=1 if (inq.completed_at - inq.created_at) < period
        completed_inquiries[:failure] +=1 if (inq.completed_at - inq.created_at) > period
      }

      completed_inquiries[:success_percentage] = (completed_inquiries[:success].fdiv(all_completed_inquires.size).round(2) * 100)
      completed_inquiries[:failure_percentage] = (completed_inquiries[:failure].fdiv(all_completed_inquires.size).round(2) * 100)
      completed_inquiries
    end
end
