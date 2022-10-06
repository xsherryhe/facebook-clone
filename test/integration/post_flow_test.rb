require "test_helper"

class PostFlowTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test "can view post timeline with user's and friend's posts after login" do
    get '/'
    assert_response :success
    assert_select 'turbo-frame'
    assert_select 'div.post-creator', 'FirstOne MiddleOne LastOne'
    assert_select 'div.post-body', 'PostOneBody'
    assert_select 'div.post-creator', 'FirstTwo MiddleTwo LastTwo'
    assert_select 'div.post-body', 'PostThreeBody'
    assert_select 'div.post-body', text: 'PostFourBody', count: 0
    assert_select 'div.post-creator', text: 'FirstSix LastSix', count: 0
  end

  test 'can create a post' do
    get new_post_path
    assert_response :success
    assert_select 'textarea[placeholder="What\'s on your mind, FirstOne?"]'

    post posts_path, params: { post: { body: '' } }
    assert_response :unprocessable_entity
    assert_select '.error', "Post can't be blank"

    post posts_path, params: { post: { body: 'PostFourBody' } }
    assert_response :redirect
    follow_redirect!

    assert_response :success
    assert_select 'turbo-frame'
    assert_select 'div.post-body', 'PostFourBody'
  end

  test 'can update a post that belongs to user' do
    get edit_post_path(posts(:post_three_from_user_two))
    assert_select '.error', /You don't have permission to edit that post\./

    post = posts(:post_two_from_user_one)
    get edit_post_path(post)
    assert_response :success

    patch post_path(post), params: { response_format: :html, post: { body: '' } }
    assert_response :unprocessable_entity
    assert_select '.error', "Post can't be blank"

    patch post_path(post), params: { response_format: :html, post: { body: 'PostFiveBody' } }
    assert_response :redirect
    follow_redirect!

    assert_response :success
    assert_select 'turbo-frame'
    assert_select 'div.post-body', 'PostFiveBody'
  end

  test 'can delete a post that belongs to user' do
    delete post_path(posts(:post_three_from_user_two), format: :turbo_stream)
    assert_select '.error', /You don't have permission to delete that post\./

    post = posts(:post_one_from_user_one)
    delete post_path(post, format: :turbo_stream)
    assert_select '.delete-message', /Successfully deleted post\./
    assert_response :success
    assert_select 'div.post-body', text: 'PostOneBody', count: 0
  end
end
