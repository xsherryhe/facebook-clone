class AddUserRefAndReactableRefToComments < ActiveRecord::Migration[7.0]
  def change
    add_reference :comments, :user, null: false, foreign_key: true
    add_reference :comments, :reactable, polymorphic: true, null: false
  end
end
