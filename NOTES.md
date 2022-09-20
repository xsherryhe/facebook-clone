DATA MODELING

User
--Devise + OmniAuth
--use username or email to log in, but username is optional
--custom password validation regex

--has_one :profile
--has_and_belongs_to_many :friends, class_name: User, 
                                    foreign_key: user_id, 
                                    association_foreign_key: friend_id
--has_many :sent_friend_requests, class_name: FriendRequest, foreign_key: sender_id
--has_many :received_friend_requests, class_name: FriendRequest, foreign_key: receiver_id
--has_many :created_posts, class_name: Post, foreign_key: creator_id
--has_many :comments
--has_many :likes
 
Profile
--(On native registration, create as nested attribute in registration form)
--(On OmniAuth user creation, use user.create_profile with args passed in)
--first_name: string
--middle_name: string
--last_name: string
--birthdate: datetime
--location: string

--belongs_to :user
--has_one :image, as: :imageable (Gravatar URLs)

FriendRequest
--belongs_to :sender, class_name: User
--belongs_to :receiver, class_name: User
--status enum accepted, pending
--(method in FriendRequest to add sender and receiver to each other's friends when accepted)

Post
--body: text

--belongs_to :creator, class_name: User
--has_many :images, as: :imageable
--has_many :comments, as: :reactable
--has_many :likes, as: :reactable

Comment
--body: text

--belongs_to :user
--belongs_to :reactable, polymorphic: true
--has_many :images, as: :imageable
--has_many :comments, as: :reactable
--has_many :likes, as: :reactable

Like
--belongs_to :user
--belongs_to :reactable, polymorphic: true

Image
--url: string

--has_one_attached :stored
--belongs_to :imageable, polymorphic: true, optional: true
--has_many :comments, as: :reactable
--has_many :likes, as: :reactable

--before validation make uri string nil if there is a stored association
--validate image has either uri string or stored association and not both

Notification
--when user receives a new friend request
--when someone accepts user's sent friend request
--when someone likes user's reactable
--when someone comments on user's reactable
--after_create hooks on friend request, like, and comment
--combine similar notifications (e.g., multiple people liking a reactable)
--body: text
--link: string
--enum view_status
--belongs_to :user
--show notifications through turbo frame to start off

STI:
--set user in before_validation hook
--belongs_to notifiable, polymorphic: true
--namespace models in Notifications subdirectory
--each model has its own body text method, link method, and set user method

Alternatively:
-belongs_to notifiable, polymorphic: true
-enum subtype
  -hash that connects type to body text method, link, and user
  -set user ref in before_validate hook
  -methods that split the hash value into body and link

Need websocket for:
-notifications
-friend request link
-live updating of posts and post times on post index page
