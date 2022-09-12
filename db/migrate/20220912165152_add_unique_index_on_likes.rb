class AddUniqueIndexOnLikes < ActiveRecord::Migration[7.0]
  def change
    add_index :likes, [:user_id, :reactable_type, :reactable_id], unique: true
  end
end
