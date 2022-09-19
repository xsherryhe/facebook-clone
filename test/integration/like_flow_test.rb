require "test_helper"

class LikeFlowTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test 'can view likes on posts' do
    get posts_path
    assert_select "div#post-#{posts(:post_one_from_user_one).id}-likes",
                  '3 likes: You, FirstThree LastThree, and FirstTwo MiddleTwo LastTwo'
  end

  test 'can view likes on comments' do
    get comments_path('comments', comments(:comment_post_one_user_two))
    assert_select "div#comment-#{comments(:comment_comment_one_user_four).id}-likes",
                  '1 like: FirstFive LastFive'
  end

  test 'can like a post' do
    target_post = posts(:post_three_from_user_two)
    post likes_path('post', target_post, format: :turbo_stream)
    assert_response :success

    get posts_path
    assert_select "div#post-#{target_post.id}-likes", '1 like: You'
    assert_select "span#post-#{target_post.id}-likes-link", 'Unlike'
  end

  test 'can like a comment' do
    target_comment = comments(:comment_comment_one_user_four)
    post likes_path('comments', target_comment, format: :turbo_stream)
    assert_response :success

    get comments_path('comments', comments(:comment_post_one_user_two))
    assert_select "div#comment-#{target_comment.id}-likes", '2 likes: You and FirstFive LastFive'
    assert_select "span#comment-#{target_comment.id}-likes-link", 'Unlike'
  end

  test 'can like an image' do
    target_image = images(:photo_post_one)
    post likes_path('images', target_image, format: :turbo_stream)
    assert_response :success

    get image_path(target_image)
    assert_select "div#image-#{target_image.id}-likes", '2 likes: You and FirstTwo MiddleTwo LastTwo'
    assert_select "span#image-#{target_image.id}-likes-link", 'Unlike'
  end

  test 'can unlike a post that the user liked' do
    delete like_path(likes(:like_one_post_one_user_three), format: :turbo_stream)
    get posts_path
    assert_select "div#post-#{posts(:post_one_from_user_one).id}-likes",
                  '3 likes: You, FirstThree LastThree, and FirstTwo MiddleTwo LastTwo'

    delete like_path(likes(:like_three_post_one_user_one), format: :turbo_stream)
    assert_response :success

    get posts_path
    assert_select "div#post-#{posts(:post_one_from_user_one).id}-likes",
                  '2 likes: FirstThree LastThree and FirstTwo MiddleTwo LastTwo'
    assert_select "span#post-#{posts(:post_one_from_user_one).id}-likes-link", 'Like'
  end

  test 'can unlike a comment that the user liked' do
    delete like_path(likes(:like_two_comment_two_user_five), format: :turbo_stream)
    get comments_path('comments', comments(:comment_post_one_user_two))
    assert_select "div#comment-#{comments(:comment_comment_one_user_four).id}-likes",
                  '1 like: FirstFive LastFive'

    delete like_path(likes(:like_four_comment_one_user_one), format: :turbo_stream)
    assert_response :success

    get comments_path('posts', posts(:post_one_from_user_one))
    assert_select "div#comment-#{comments(:comment_post_one_user_two).id}-likes",
                  text: '1 like: You', count: 0
    assert_select "span#comment-#{comments(:comment_post_one_user_two).id}-likes-link", 'Like'
  end

  test 'can unlike an image that the user liked' do
    delete like_path(likes(:like_five_photo_seven_user_two), format: :turbo_stream)
    get image_path(images(:photo_post_one))
    assert_select "div#image-#{images(:photo_post_one).id}-likes",
                  '1 like: FirstTwo MiddleTwo LastTwo'

    delete like_path(likes(:like_seven_photo_eight_user_one), format: :turbo_stream)
    assert_response :success

    get image_path(images(:photo_comment_one))
    assert_select "div#image-#{images(:photo_comment_one).id}-likes",
                  text: '1 like: You', count: 0
    assert_select "span#image-#{images(:photo_comment_one).id}-likes-link", 'Like'
  end
end
