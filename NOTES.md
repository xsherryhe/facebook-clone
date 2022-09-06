DATA MODELING

User
-Devise + OmniAuth
-custom password validation regex

-has_one :profile
-has_and_belongs_to_many :friends, class_name: User, 
                                  foreign_key: this_friend_id, 
                                  association_foreign_key: other_friend_id
-has_many :sent_friend_requests, class_name: FriendRequest, foreign_key: sender_id
-has_many :received_friend_requests, class_name: FriendRequest, foreign_key: receiver_id
-has_many :created_posts, class_name: Post, foreign_key: creator_id
-has_many :comments
-has_many :likes
 
Profile
(On native registration, create as nested attribute in registration form)
(On OmniAuth user creation, use user.create_profile with args passed in)
-first_name: string
-middle_name: string
-last_name: string
-birthdate: datetime
-location: string
-photo (Gravatar API - update README when this is implemented)

-belongs_to :user
-has_one :image, as: :imageable

FriendRequest
-belongs_to :sender, class_name: User
-belongs_to :receiver, class_name: User
-status enum accepted, not_responded, declined
-(method in FriendRequest to add sender and receiver to each other's friends when accepted)

Post
-body: text

-belongs_to :creator, class_name: User
-has_many :images
-has_many :comments, as: :reactable
-has_many :likes, as: :reactable

Comment
-body: text

-belongs_to :user
-belongs_to :reactable, polymorphic: true
-has_many :images, as: :imageable

Like
-belongs_to :user
-belongs_to :reactable, polymorphic: true

Image
-Active Storage
-uri: string

-belongs_to :imageable, polymorphic: true, optional: true
-has_many :comments, as: :reactable
-has_many :likes, as: :reactable

