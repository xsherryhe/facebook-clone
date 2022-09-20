class Notifications::LikeNotification < Notification
  alias_attribute :like, :notifiable

  def initiator
    like.user
  end

  def initiator_action
    "liked your #{reactable_model_name}"
  end

  def link
    public_send("#{reactable_root_model_singular_route_key}_path", like.reactable_root)
  end

  def groupable?
    true
  end

  def group_dimension
    like.reactable
  end

  def associations_for_includes
    { like: [{ user: :profile }, :reactable, :reactable_root] }
  end

  private

  def set_user
    self.user = like.reactable.creator
  end
end
