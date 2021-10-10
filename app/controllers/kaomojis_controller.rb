# frozen_string_literal: true

class KaomojisController < ApplicationController
  def index
    @kaomojis = UniqueKaomoji.order(:kaomoji)
    @kaomojis = @kaomojis.oneline if oneline
    @kaomojis = @kaomojis.page params[:page]
  end

  private

  def oneline
    params[:oneline]
  end
end
