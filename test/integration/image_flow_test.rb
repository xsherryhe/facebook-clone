require "test_helper"

class ImageFlowTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test 'can create a post with a single image only' do
    post posts_path,
         params: { post: { raw_photos: [fixture_file_upload('chocolates2.jpg', 'image/jpeg')] } }
    assert_response :redirect
    follow_redirect!

    assert_response :success
    assert_select "img:match('src',?)", /chocolates2.jpg/
  end

  test 'can create a post with multiple images' do
    post posts_path,
         params: { post: { raw_photos: [fixture_file_upload('chocolates1.jpg', 'image/jpeg'),
                                        fixture_file_upload('chocolates2.jpg', 'image/jpeg')] } }
    assert_response :redirect
    follow_redirect!

    assert_response :success
    assert_select "img:match('src',?)", /chocolates1\.jpg/
    assert_select "img:match('src',?)", /chocolates2\.jpg/
  end

  test 'can create a post with an image and text' do
    post posts_path,
         params: { post: { body: 'Look at my chocolates.',
                           raw_photos: [fixture_file_upload('chocolates1.jpg', 'image/jpeg')] } }
    assert_response :redirect
    follow_redirect!

    assert_response :success
    assert_select 'div.body', 'Look at my chocolates.'
    assert_select "img:match('src',?)", /chocolates1\.jpg/
  end

  test 'can view image' do
    get image_path(images(:photo_post_one))
    assert_response :success

    assert_select "img:match('src',?)", /koi-fish\.png/
  end

  test 'can view post likes on the image for single-image posts' do
    target_post = posts(:post_five_from_user_one)
    post likes_path('posts', target_post, format: :turbo_stream)

    get image_path(target_post.photos.first)
    assert_select "div#post-#{target_post.id}-likes", '1 like: You'
  end
end
