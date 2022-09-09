# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.destroy_all

50.times do
  User.create(email: Faker::Internet.email,
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

50.times do
  string = Faker::String.random
  User.find(User.pluck(:id).sample).created_posts.create(body: string)
end

50.times do
  User.find(User.pluck(:id).sample).created_posts.create(body: Faker::Lorem.paragraph(random_sentences_to_add: 10))
end
