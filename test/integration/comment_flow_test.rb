require "test_helper"

class CommentFlowTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test 'can view comments on a post and form for new comment' do
    get comments_path('post', posts(:post_one_from_user_one))
    assert_response :success
    assert_select 'div.body', 'CommentOneBody'
    assert_select 'div.body', 'CommentThreeBody'
    assert_select 'textarea[name="comment[body]"]'
  end

  test 'can view comments on a comment and form for new comment' do
    get comments_path('comment', comments(:comment_post_one_user_two))
    assert_response :success
    assert_select 'div.body', 'ReplyOneToCommentOne'
    assert_select 'textarea[name="comment[body]"]'
  end

  test 'can create a comment on a post' do
    post comments_path('post', posts(:post_three_from_user_two)),
         params: { comment: { body: '' } }
    assert_response :unprocessable_entity
    assert_select 'p.error', "Body can't be blank"

    post comments_path('post', posts(:post_three_from_user_two), format: :turbo_stream),
         params: { comment: { body: 'Created Comment on a Post' } }
    assert_response :success
    assert_select 'div.user', 'FirstOne MiddleOne LastOne'
    assert_select 'div.body', 'Created Comment on a Post'
  end

  test 'can create a comment on a comment' do
    post comments_path('comment', comments(:comment_post_one_user_one)),
         params: { comment: { body: '' } }
    assert_response :unprocessable_entity
    assert_select 'p.error', "Body can't be blank"

    post comments_path('comment', comments(:comment_post_one_user_one), format: :turbo_stream),
         params: { comment: { body: 'Created Comment on a Comment' } }
    assert_response :success
    assert_select 'div.user', 'FirstOne MiddleOne LastOne'
    assert_select 'div.body', 'Created Comment on a Comment'
  end

  test "can update user's own comment on a post" do
    get edit_comment_path(comments(:comment_post_one_user_two))
    assert_equal("You don't have permission to edit that comment.", flash[:error])
    assert_response :redirect

    get edit_comment_path(comments(:comment_post_one_user_one))
    assert_response :success
    assert_select 'textarea', 'CommentThreeBody'

    patch comment_path(comments(:comment_post_one_user_one)),
          params: { comment: { body: '' } }
    assert_response :unprocessable_entity
    assert_select 'p.error', "Body can't be blank"

    patch comment_path(comments(:comment_post_one_user_one)),
          params: { comment: { body: 'Updated comment on this post' } }
    assert_response :success
    assert_select 'div.body', 'Updated comment on this post'
  end

  test "can update user's own comment on a comment" do
    get edit_comment_path(comments(:comment_comment_one_user_four))
    assert_equal("You don't have permission to edit that comment.", flash[:error])
    assert_response :redirect

    get edit_comment_path(comments(:comment_comment_one_user_one))
    assert_response :success
    assert_select 'textarea', 'ReplyTwoToCommentOne'

    patch comment_path(comments(:comment_comment_one_user_one)),
          params: { comment: { body: '' } }
    assert_response :unprocessable_entity
    assert_select 'p.error', "Body can't be blank"

    patch comment_path(comments(:comment_comment_one_user_one)),
          params: { comment: { body: 'Updated comment on this comment' } }
    assert_response :success
    assert_select 'div.body', 'Updated comment on this comment'
  end

  test "can delete user's own comment on a post" do
    delete comment_path(comments(:comment_post_one_user_two))
    assert_equal("You don't have permission to delete that comment.", flash[:error])
    assert_response :redirect

    delete comment_path(comments(:comment_post_one_user_one))
    assert_response :success
    assert_select 'div.body', text: 'CommentThreeBody', count: 0
  end

  test "can delete user's own comment on a comment" do
    delete comment_path(comments(:comment_comment_one_user_four))
    assert_equal("You don't have permission to delete that comment.", flash[:error])
    assert_response :redirect

    delete comment_path(comments(:comment_comment_one_user_one))
    assert_response :success
    assert_select 'div.body', text: 'ReplyTwoToCommentOne', count: 0
  end
end
