class AddUserRefAndReactableRefToLikes < ActiveRecord::Migration[7.0]
  def change
    add_reference :likes, :user, null: false, foreign_key: true
    add_reference :likes, :reactable, polymorphic: true, null: false
  end
end
