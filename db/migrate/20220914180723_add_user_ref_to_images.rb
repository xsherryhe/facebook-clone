class AddUserRefToImages < ActiveRecord::Migration[7.0]
  def change
    add_reference :images, :user, null: false, foreign_key: true
  end
end
