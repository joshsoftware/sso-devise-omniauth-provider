class AuthenticationsController < ApplicationController
  before_filter :authenticate_user!, :except => [:create]

  def index
    @authentications = current_user.authentications.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @authentications }
    end
  end

  def new
    @authentication = Authentication.new
  end

  # TODO: Account linking. Example, if a user has signed in via twitter using the
  # email abc@xyz.com and then signs in via Facebook with the same id, we should
  # link these 2 accounts. Since, we already have Authentication model in place,
  # user should be asked for login credentials and then teh new authentication should 
  # be linked.
  # (Gautam)
  def create
    omniauth = request.env['omniauth.auth']
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = "Signed in successfully"
      sign_in_and_redirect(:user, authentication.user)
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Successfully registered"
        sign_in_and_redirect(:user, user)
      else
        session[:omniauth] = omniauth.except('extra')
        session[:omniauth_email] = omniauth['extra'] && omniauth['extra']['user_hash'] && omniauth['extra']['user_hash']['email']
        redirect_to new_user_registration_url
      end
    end
  end

  def faiure
    flash[:notice] = params[:message]
    redirect_to root_path
  end

  def destroy
    @authentication = Authentication.find(params[:id])
    @authentication.destroy

    respond_to do |format|
      format.html { redirect_to(authentications_url) }
      format.xml  { head :ok }
    end
  end
end
