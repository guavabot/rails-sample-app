class StaticPagesController < ApplicationController
  def home
    @tweet = current_user.tweets.build if logged_in?
  end

  def help
  end

  def about
  end

  def contact
  end
end
