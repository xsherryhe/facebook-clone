module TimeDisplayable
  extend ActiveSupport::Concern

  def created_at_full_display
    created_at.strftime('%A, %B %-d, %Y at %-l:%M %p')
  end

  def created_at_abbr_display
    time = created_at
    if time > Time.current - 1.day
      diff_in_hours(time)
    elsif time > Time.current - 1.week
      diff_in_days(time)
    elsif time > Time.current - 1.year
      day_time_display(time)
    else
      day_year_display(time)
    end
  end

  private

  def diff_in_hours(time)
    "#{((Time.current - time) / 3600).round}h"
  end

  def diff_in_days(time)
    "#{((Time.current - time) / 86_400).round}d"
  end

  def day_time_display(time)
    time.strftime('%B %-d at %-l:%M %p')
  end

  def day_year_display(time)
    time.strftime('%B %-d, %Y')
  end
end
