class ChangeBirthdateDatetimeToDate < ActiveRecord::Migration[7.0]
  def change
    change_column :profiles, :birthdate, :date
  end
end
