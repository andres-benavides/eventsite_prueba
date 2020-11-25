class WelcomeController < ActionController::Base

  def show
    @url_site = Rails.application.routes.default_url_options[:host]
  end
end