class UniqueKaomoji < ApplicationRecord
  def select!
    update!(selected: true)
  end

  def unselect!
    update!(selected: false)
  end
end
