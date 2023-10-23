class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  # フォローをした、されたの関係
  has_many :followers, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followeds, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  # 一覧画面で使う
  has_many :following_users, through: :followers, source: :followed
  has_many :follower_users, through: :followeds, source: :follower

  has_one_attached :profile_image

    validates :name, presence: true, uniqueness: true,
      length: { minimum: 2, maximum: 20 }
    validates :introduction,
       length: { maximum: 50 }


  def get_profile_image(width,height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/default-image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

    #　フォローしたときの処理
  def follow(user_id)
    unless user_id == id
      followers.create(followed_id: user_id)
    end
  end

  #　フォローを外すときの処理
  def unfollow(user_id)
    unless user_id == id
      followers.find_by(followed_id: user_id).destroy
    end
  end

  #フォローしていればtrueを返す
  def following?(user)
    following_users.include?(user)
  end

  def self.search_for(content, method, column_name = "name")
    query = "#{column_name} LIKE ?"
    case method
    when 'perfect'
      User.where(column_name => content)
    when 'forward'
      User.where(query, "#{content}%")
    when 'backward'
      User.where(query, "%#{content}")
    else
      User.where(query, "%#{content}%")
    end
  end

end
