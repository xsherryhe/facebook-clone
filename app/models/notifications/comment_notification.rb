class Notifications::CommentNotification < Notification
  alias_attribute :comment, :notifiable

  def initiator
    comment.user
  end

  def initiator_action
    "commented on your #{reactable_model_name}"
  end

  def link
    public_send("#{reactable_model_singular_route_key}_path", comment.reactable)
  end

  def groupable?
    true
  end

  def group_dimension
    comment.reactable
  end

  def associations_for_includes
    { comment: [{ user: :profile }, :reactable] }
  end

  private

  def set_user
    self.user = comment.reactable.creator
  end
end
