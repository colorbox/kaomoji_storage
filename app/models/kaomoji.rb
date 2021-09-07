class Kaomoji < ApplicationRecord
  belongs_to :tweet

  def select!
    update!(selected: true)
  end

  def unselect!
    update!(selected: false)
  end
end
