class Group < ApplicationRecord
  has_many :group_users, dependent: :destroy
  belongs_to :owner, class_name: "User"
  has_many :users, through: :group_users, source: :user

  validates :name, presence: true
  validates :introduction, presence: true
  has_one_attached :group_image

  def get_group_image
    (group_image.attached?) ? group_image : 'app/assets/images/default-image.jpg'
  end

  def get_group_image(width,height)
    unless group_image.attached?
      file_path = Rails.root.join('app/assets/images/default-image.jpg')
      group_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    group_image.variant(resize_to_limit: [width, height]).processed
  end

  def is_owned_by?(user)
    owner.id == user.id
  end

  def include_user?(user)
    group_users.exists?(user_id: user.id)
  end
end
