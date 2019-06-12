class ResidencyHiring
  START_DATE = "October 1"
  END_DATE = "January 19"

  def self.active?
    new.active?
  end

  def active?
    date_range.include? time_string(Time.now)
  end

  private
  def time_string(time_or_date)
    time_or_date.strftime("%B %e").squeeze
  end

  def start_date
    Date.parse(START_DATE) << 12
  end

  def end_date
    Date.parse(END_DATE)
  end

  def date_range
    check_date_range
    (start_date..end_date).map {
      |day| time_string(day)
    }
  end

  def check_date_range
    unless START_DATE == time_string(start_date)
      throw "start_date method return value does not match constant START_DATE. #{START_DATE} does not equal #{time_string(start_date)}"
    end
  end

end
