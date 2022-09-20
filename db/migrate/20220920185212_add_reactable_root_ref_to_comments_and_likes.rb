class AddReactableRootRefToCommentsAndLikes < ActiveRecord::Migration[7.0]
  def change
    add_reference :likes, :reactable_root, polymorphic: true, null: false
    add_reference :comments, :reactable_root, polymorphic: true, null: false
  end
end
