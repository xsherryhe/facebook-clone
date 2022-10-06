require "test_helper"

class CommentFlowTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test 'can view preview of comments on a post' do
    get posts_path
    assert_select 'div.comment-body', 'CommentOneBody'
    assert_select 'div.comment-body', 'CommentThreeBody'
    assert_select 'div.comment-body', text: 'CommentSevenBody', count: 0
  end

  test 'can view preview of comments on an image' do
    get image_path(images(:photo_post_one))
    assert_select 'div.comment-body', 'CommentFiveBody'
    assert_select 'div.comment-body', 'CommentSixBody'
    assert_select 'div.comment-body', text: 'CommentNineBody', count: 0
  end

  test 'can view form for new comment on a post' do
    get comments_path('posts', posts(:post_one_from_user_one))
    assert_response :success
    assert_select 'textarea[name="comment[body]"]'
  end

  test 'can view preview of comments on a comment and form for new comment' do
    get comments_path('comments', comments(:comment_post_one_user_two))
    assert_response :success
    assert_select 'div.comment-body', 'ReplyOneToCommentOne'
    assert_select 'div.comment-body', 'ReplyTwoToCommentOne'
    assert_select 'div.comment-body', text: 'ReplyThreeToCommentOne', count: 0
    assert_select 'textarea[name="comment[body]"]'
  end

  test 'can view form for new comment on an image' do
    get comments_path('images', images(:photo_post_one))
    assert_response :success
    assert_select 'textarea[name="comment[body]"]'
  end

  test 'can view additional comments after preview on a post' do
    get comments_path('posts', posts(:post_one_from_user_one), page: 1)
    assert_response :success
    assert_select 'div.comment-body', 'CommentOneBody'
    assert_select 'div.comment-body', 'CommentThreeBody'
    assert_select 'div.comment-body', 'CommentSevenBody'
  end

  test 'can view additional comments after preview on a comment' do
    get comments_path('comments', comments(:comment_post_one_user_two), page: 1)
    assert_response :success
    assert_select 'div.comment-body', 'ReplyOneToCommentOne'
    assert_select 'div.comment-body', 'ReplyTwoToCommentOne'
    assert_select 'div.comment-body', 'ReplyThreeToCommentOne'
  end

  test 'can view additional comments after preview on an image' do
    get comments_path('images', images(:photo_post_one), page: 1)
    assert_response :success
    assert_select 'div.comment-body', 'CommentFiveBody'
    assert_select 'div.comment-body', 'CommentSixBody'
    assert_select 'div.comment-body', 'CommentNineBody'
  end

  test 'can create a comment on a post' do
    post comments_path('posts', posts(:post_three_from_user_two)),
         params: { comment: { body: '' } }
    assert_response :unprocessable_entity
    assert_select '.error', "Comment can't be blank"

    post comments_path('posts', posts(:post_three_from_user_two), format: :turbo_stream),
         params: { comment: { body: 'Created Comment on a Post' } }
    assert_response :success
    assert_select 'div.user', 'FirstOne MiddleOne LastOne'
    assert_select 'div.comment-body', 'Created Comment on a Post'
  end

  test 'can create a comment on a comment' do
    post comments_path('comments', comments(:comment_post_one_user_one)),
         params: { comment: { body: '' } }
    assert_response :unprocessable_entity
    assert_select '.error', "Comment can't be blank"

    post comments_path('comments', comments(:comment_post_one_user_one), format: :turbo_stream),
         params: { comment: { body: 'Created Comment on a Comment' } }
    assert_response :success
    assert_select 'div.user', 'FirstOne MiddleOne LastOne'
    assert_select 'div.comment-body', 'Created Comment on a Comment'
  end

  test 'can create a comment on an image' do
    post comments_path('images', images(:photo_post_one)),
         params: { comment: { body: '' } }
    assert_response :unprocessable_entity
    assert_select '.error', "Comment can't be blank"

    post comments_path('images', images(:photo_post_one), format: :turbo_stream),
         params: { comment: { body: 'Created Comment on an Image' } }
    assert_response :success
    assert_select 'div.user', 'FirstOne MiddleOne LastOne'
    assert_select 'div.comment-body', 'Created Comment on an Image'
  end

  test "can update user's own comment on a post" do
    get edit_comment_path('posts', posts(:post_one_from_user_one), comments(:comment_post_one_user_two))
    assert_select '.error', /You don't have permission to edit that comment\./

    get edit_comment_path('posts', posts(:post_one_from_user_one), comments(:comment_post_one_user_one))
    assert_response :success
    assert_select 'textarea', 'CommentThreeBody'

    patch comment_path('posts', posts(:post_one_from_user_one), comments(:comment_post_one_user_one)),
          params: { comment: { body: '' } }
    assert_response :unprocessable_entity
    assert_select '.error', "Comment can't be blank"

    patch comment_path('posts', posts(:post_one_from_user_one), comments(:comment_post_one_user_one)),
          params: { comment: { body: 'Updated comment on this post' } }
    assert_response :success
    assert_select 'div.comment-body', 'Updated comment on this post'
  end

  test "can update user's own comment on a comment" do
    get edit_comment_path('comments', comments(:comment_post_one_user_one), comments(:comment_comment_one_user_four))
    assert_select '.error', /You don't have permission to edit that comment\./

    get edit_comment_path('comments', comments(:comment_post_one_user_one), comments(:comment_comment_one_user_one))
    assert_response :success
    assert_select 'textarea', 'ReplyTwoToCommentOne'

    patch comment_path('comments', comments(:comment_post_one_user_one), comments(:comment_comment_one_user_one)),
          params: { comment: { body: '' } }
    assert_response :unprocessable_entity
    assert_select '.error', "Comment can't be blank"

    patch comment_path('comments', comments(:comment_post_one_user_one), comments(:comment_comment_one_user_one)),
          params: { comment: { body: 'Updated comment on this comment' } }
    assert_response :success
    assert_select 'div.comment-body', 'Updated comment on this comment'
  end

  test "can update user's own comment on an image" do
    get edit_comment_path('images', images(:photo_post_one), comments(:comment_photo_seven_user_three))
    assert_select '.error', /You don't have permission to edit that comment\./

    get edit_comment_path('images', images(:photo_post_one), comments(:comment_photo_seven_user_one))
    assert_response :success
    assert_select 'textarea', 'CommentSixBody'

    patch comment_path('images', images(:photo_post_one), comments(:comment_photo_seven_user_one)),
          params: { comment: { body: '' } }
    assert_response :unprocessable_entity
    assert_select '.error', "Comment can't be blank"

    patch comment_path('images', images(:photo_post_one), comments(:comment_photo_seven_user_one)),
          params: { comment: { body: 'Updated comment on this image' } }
    assert_response :success
    assert_select 'div.comment-body', 'Updated comment on this image'
  end

  test "can delete user's own comment on a post" do
    delete comment_path('posts', posts(:post_one_from_user_one), comments(:comment_post_one_user_two))
    assert_select '.error', /You don't have permission to delete that comment\./

    delete comment_path('posts', posts(:post_one_from_user_one), comments(:comment_post_one_user_one))
    assert_response :success
    assert_select 'div.comment-body', text: 'CommentThreeBody', count: 0
  end

  test "can delete user's own comment on a comment" do
    delete comment_path('comments', comments(:comment_post_one_user_two), comments(:comment_comment_one_user_four))
    assert_select '.error', /You don't have permission to delete that comment\./

    delete comment_path('comments', comments(:comment_post_one_user_two), comments(:comment_comment_one_user_one))
    assert_response :success
    assert_select 'div.comment-body', text: 'ReplyTwoToCommentOne', count: 0
  end

  test "can delete user's own comment on an image" do
    delete comment_path('images', images(:photo_post_one), comments(:comment_photo_seven_user_three))
    assert_select '.error', /You don't have permission to delete that comment\./

    delete comment_path('images', images(:photo_post_one), comments(:comment_photo_seven_user_one))
    assert_response :success
    assert_select 'div.comment-body', text: 'CommentSixBody', count: 0
  end
end
