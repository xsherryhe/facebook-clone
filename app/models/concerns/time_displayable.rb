module TimeDisplayable
  extend ActiveSupport::Concern

  def created_at_full_display
    created_at.localtime.strftime('%A, %B %-d, %Y at %-l:%M %p')
  end

  def created_at_abbr_display
    time = created_at.localtime
    if time > Time.current - 59.seconds then 'Now'
    elsif time > Time.current - 59.minutes then diff_in_minutes(time)
    elsif time > Time.current - 23.hours then diff_in_hours(time)
    elsif time > Time.current - 6.days then diff_in_days(time)
    elsif time.year == Time.current.year then day_time_display(time)
    else
      day_year_display(time)
    end
  end

  private

  def diff_in_minutes(time)
    "#{((Time.current - time) / 60).round}m"
  end

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
