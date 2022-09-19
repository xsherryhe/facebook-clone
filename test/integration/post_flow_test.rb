require "test_helper"

class PostFlowTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test "can view post timeline with user's and friend's posts after login" do
    get '/'
    assert_response :success
    assert_select 'turbo-frame'
    assert_select 'div.creator', 'FirstOne MiddleOne LastOne'
    assert_select 'div.body', 'PostOneBody'
    assert_select 'div.creator', 'FirstTwo MiddleTwo LastTwo'
    assert_select 'div.body', 'PostThreeBody'
    assert_select 'div.body', text: 'PostFourBody', count: 0
    assert_select 'div.creator', text: 'FirstSix LastSix', count: 0
  end

  test 'can create a post' do
    get new_post_path
    assert_response :success
    assert_select 'textarea[placeholder="What\'s on your mind, FirstOne?"]'

    post posts_path, params: { post: { body: '' } }
    assert_response :unprocessable_entity
    assert_select 'p.error', "Post can't be blank"

    post posts_path, params: { post: { body: 'PostFourBody' } }
    assert_response :redirect
    follow_redirect!

    assert_response :success
    assert_select 'turbo-frame'
    assert_select 'div.body', 'PostFourBody'
  end

  test 'can update a post that belongs to user' do
    get edit_post_path(posts(:post_three_from_user_two))
    assert_equal("You don't have permission to edit that post.", flash[:error])
    assert_response :redirect

    post = posts(:post_two_from_user_one)
    get edit_post_path(post)
    assert_response :success

    patch post_path(post), params: { response_format: :html, post: { body: '' } }
    assert_response :unprocessable_entity
    assert_select 'p.error', "Post can't be blank"

    patch post_path(post), params: { response_format: :html, post: { body: 'PostFiveBody' } }
    assert_response :redirect
    follow_redirect!

    assert_response :success
    assert_select 'turbo-frame'
    assert_select 'div.body', 'PostFiveBody'
  end

  test 'can delete a post that belongs to user' do
    delete post_path(posts(:post_three_from_user_two))
    assert_equal("You don't have permission to delete that post.", flash[:error])
    assert_response :redirect

    post = posts(:post_one_from_user_one)
    delete post_path(post)
    assert_equal('Successfully deleted post.', flash[:notice])
    assert_response :redirect
    follow_redirect!

    assert_response :success
    assert_select 'turbo-frame'
    assert_select 'div.body', text: 'PostOneBody', count: 0
  end
end
