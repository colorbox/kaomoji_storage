class KaomojiSelectController < ApplicationController
  before_action :set_kaomoji
  def update(kaomoji_id)
    if @kaomoji.selected?
      @kaomoji.unselect!
    else
      @kaomoji.select!
    end
  end

  private

  def set_kaomoji
    @kaomoji ||= UniqueKaomoji.find(kaomoji_params[:kaomoji_id])
  end

  def kaomoji_params
    params.permit(:kaomoji_id)
  end
end
