class Micropost < ApplicationRecord
  belongs_to :user
  delegate :name, to: :user
  # default_scope ->{order created_at: :desc}
  scope :recent_posts, ->{order created_at: :desc}
  scope :microposts_with_ids, -> ids{where(user_id: ids)}

  has_one_attached :image
  validates :content, presence: true,
    length: {maximum: Settings.validation.content_max}
  validates :image, content_type: {in: %i(gif png jpg jpeg),
                                   message: I18n.t("microposts.image_type")},
                    size: {less_than: Settings.image.size.megabytes,
                           message: I18n.t("microposts.image_size")}
  def display_image
    image.variant resize_to_limit: [Settings.image.show,
                                    Settings.image.show]
  end
end
