# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.destroy_all

User.create(email: 'user123@email.com',
            username: 'user123',
            password: ENV['user123_password'],
            profile_attributes: {
              first_name: 'Us',
              middle_name: 'E.',
              last_name: 'R123',
              birthdate: Date.new(1990, 5, 20),
              location: 'Earth, Galaxy'
            })

User.create(email: 'user456@email.com',
            username: 'user456',
            password: ENV['user456_password'],
            profile_attributes: {
              first_name: 'User',
              last_name: '456',
              birthdate: Date.new(1985, 8, 14)
            })

20.times do
  User.create(email: Faker::Internet.email,
              username: [nil, Faker::Internet.username].sample,
              password: Faker::Internet.password(min_length: 6, special_characters: true),
              profile_attributes: { first_name: Faker::Name.first_name,
                                    middle_name: [nil, Faker::Name.middle_name].sample,
                                    last_name: Faker::Name.last_name,
                                    birthdate: [nil, Faker::Date.birthday(min_age: 12, max_age: 100)].sample,
                                    location: [nil,
                                               Faker::Address.city,
                                               Faker::Address.state,
                                               "#{Faker::Address.city}, #{Faker::Address.state}",
                                               Faker::Address.country].sample })
end

user_ids = User.pluck(:id).shuffle * 2
user_ind = 0

if Rails.env.development?
  5.times do
    User.find(user_ids[user_ind]).created_posts.create(body: Faker::String.random)
    User.find(user_ids[user_ind + 1]).created_posts.create(body: Faker::Lorem.paragraph(random_sentences_to_add: 10))
    user_ind += 2
  end

  post_ids = Post.pluck(:id).shuffle * 2
  post_ind = 0

  post_ids[post_ind..post_ind + 4].zip(user_ids[user_ind..user_ind + 4]).each do |post_id, user_id|
    Post.find(post_id).comments.create(user_id:, body: Faker::String.random)
  end
  user_ind += 5
  post_ind += 5

  comment_ids = Comment.pluck(:id).shuffle * 2
  comment_ind = 0

  comment_ids[comment_ind..comment_ind + 4].zip(user_ids[user_ind..user_ind + 4]).each do |comment_id, user_id|
    Comment.find(comment_id).comments.create(user_id:, body: Faker::String.random)
  end
  user_ind += 5
  comment_ind += 5

  5.times do
    user_id = user_ids[user_ind]
    post = Post.find(post_ids[post_ind])
    comment = Comment.find(comment_ids[comment_ind])
    [post, comment].each do |reactable|
      reactable.likes.create(user_id:) unless Like.exists?(reactable:, user_id:)
    end
    user_ind += 1
    post_ind += 1
    comment_ind += 1
  end
end

user123 = User.find_by(username: 'user123')
user456 = User.find_by(username: 'user456')
user_ids[user_ind..user_ind + 3].each do |id|
  user = User.find(id)
  user123.add_friend(user)
  user.sent_friend_requests.create(receiver: user456) unless user == user456
end

post = user123.created_posts.create(body: 'How is everyone today?')
comment = post.comments.create(user_id: user_ids[user_ind], body: "I'm feeling great!")
comment.comments.create(user_id: user_ids[user_ind + 1], body: 'That is wonderful.')
post.likes.create(user_id: user_ids[user_ind + 2])
comment.likes.create(user_id: user_ids[user_ind + 3])
user_ind += 4

post_with_image = user456.created_posts.create(body: 'Look at these delicious chocolates.')
image = post_with_image.photos.build(user: post_with_image.creator)
image.stored.attach(io: File.open('test/fixtures/files/chocolates1.jpg'),
                    filename: 'chocolates1.jpg',
                    content_type: 'image/jpeg')
image.save
