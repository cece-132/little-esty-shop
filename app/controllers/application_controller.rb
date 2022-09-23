class ApplicationController < ActionController::Base
  # before_action :get_github_footer

  # def get_github_footer
  #   @github_info = GithubFacade.get_github_data
  # end

  private

  def error_message(errors)
    errors.full_messages.join(', ')
  end
end

