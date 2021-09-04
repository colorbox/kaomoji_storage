# frozen_string_literal: true

class KaomojisController < ApplicationController
  def index
    @kaomojis = Kaomoji.order(:kaomoji).page params[:page]
  end
end
