# frozen_string_literal: true

class KaomojisController < ApplicationController
  def index
    @kaomojis = UniqueKaomoji.order(:kaomoji).page params[:page]
  end
end
