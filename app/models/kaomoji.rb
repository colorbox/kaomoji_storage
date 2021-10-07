class Kaomoji < ApplicationRecord
  belongs_to :tweet

  scope :not_unique_filtered, -> { where(unique_filtered_at: nil) }
  scope :unique_filtered, -> { where.not(unique_filtered_at: nil) }

  def select!
    update!(selected: true)
  end

  def unselect!
    update!(selected: false)
  end
end
