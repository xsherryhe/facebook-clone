require "test_helper"

class NotificationsFlowTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test 'can view notifications' do
    get notifications_path
    assert_response :success
    assert_select 'div.notification', /FirstFive LastFive sent you a friend request\./
    assert_select 'div.notification', /FirstThree LastThree and FirstTwo MiddleTwo LastTwo liked your post\./
    assert_select 'div.notification', /FirstTwo MiddleTwo LastTwo commented on your post\./
  end

  test 'can view friend request notification after receiving friend request' do
    post friend_requests_path, params: { receiver_id: users(:four).id }

    sign_in users(:four)
    get notifications_path
    assert_response :success
    assert_select 'div.notification', /FirstOne MiddleOne LastOne sent you a friend request\./
  end

  test 'can view friend notification after having friend request accepted' do
    post friend_path(users(:five))

    sign_in users(:five)
    get notifications_path
    assert_response :success
    assert_select 'div.notification', /FirstOne MiddleOne LastOne accepted your friend request\./
  end

  test 'can view like notifications after receiving likes from other users' do
    post likes_path('posts', posts(:post_two_from_user_one), format: :turbo_stream)
    get notifications_path
    assert_select 'div.notification',
                  text: /FirstOne MiddleOne LastOne liked your post\./,
                  count: 0

    post likes_path('comments', comments(:comment_comment_one_user_four), format: :turbo_stream)
    sign_in users(:four)
    get notifications_path
    assert_response :success
    assert_select 'div.notification', /FirstOne MiddleOne LastOne liked your comment\./

    sign_in users(:two)
    post likes_path('comments', comments(:comment_comment_one_user_four), format: :turbo_stream)
    sign_in users(:four)
    get notifications_path
    assert_response :success
    assert_select 'div.notification', /FirstOne MiddleOne LastOne and FirstTwo MiddleTwo LastTwo liked your comment\./
  end

  test 'can view comment notifications after receiving comments from other users' do
    post comments_path('posts', posts(:post_two_from_user_one), format: :turbo_stream),
         params: { comment: { body: 'Comment on Post Two' } }
    get notifications_path
    assert_select 'div.notification',
                  text: /FirstOne MiddleOne LastOne commented on your post\./,
                  count: 0

    post comments_path('images', images(:photo_comment_one), format: :turbo_stream),
         params: { comment: { body: 'Comment on Photo Eight' } }
    sign_in users(:two)
    get notifications_path
    assert_response :success
    assert_select 'div.notification', /FirstOne MiddleOne LastOne commented on your photo\./

    sign_in users(:three)
    post comments_path('images', images(:photo_comment_one), format: :turbo_stream),
         params: { comment: { body: 'Comment from User Three on Photo Eight' } }
    sign_in users(:two)
    get notifications_path
    assert_response :success
    assert_select 'div.notification', /FirstOne MiddleOne LastOne and FirstThree LastThree commented on your photo\./
  end
end
