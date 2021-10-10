class UniqueKaomoji < ApplicationRecord

  scope :oneline, -> { where("kaomoji not like '%\n%'") }

  def select!
    update!(selected: true)
  end

  def unselect!
    update!(selected: false)
  end
end
