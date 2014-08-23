class StaticController < ApplicationController
  before_filter { redirect_to(after_sign_in_path_for(current_user)) if user_signed_in? }
end
