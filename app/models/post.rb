class Post < ApplicationRecord
  validates :body, presence: true
  belongs_to :creator, class_name: 'User'

  def created_at_full_display
    created_at.strftime('%A, %B %-d, %Y at %-l:%M %p')
  end

  def created_at_abbr_display
    post_time = created_at
    if post_time > Time.current - 1.day
      diff_in_hours(post_time)
    elsif post_time > Time.current - 1.week
      diff_in_days(post_time)
    elsif post_time > Time.current - 1.year
      day_time_display(post_time)
    else
      day_year_display(post_time)
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
