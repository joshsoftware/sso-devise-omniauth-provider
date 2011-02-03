class RegistrationsController < Devise::RegistrationsController
  before_filter :save_referrer, :only => :edit

  def new
     # Building the resource with information that MAY BE available from omniauth!
     build_resource(:first_name => session[:omniauth] && session[:omniauth]['user_info'] && session[:omniauth]['user_info']['first_name'], 
         :last_name => session[:omniauth] && session[:omniauth]['user_info'] && session[:omniauth]['user_info']['last_name'],
         :email => session[:omniauth_email] )
     render_with_scope :new
  end

  def create
    super
    session[:omniauth] = nil unless @user.new_record?
  end
  
  def build_resource(*args)
    super

    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end

  def after_update_path_for(scope)
    session[:referrer] ? session[:referrer] : root_path
  end
end
