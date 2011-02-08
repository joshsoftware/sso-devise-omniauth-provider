class AuthenticationsController < ApplicationController
  before_filter :authenticate_user!, :except => [:create, :link, :add]

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

  def add
    user = User.find(params[:user_id])
    if user.valid_password?(params[:user][:password])
      omniauth = session[:omniauth]
      user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      session[:omniauth] = nil
      sign_in_and_redirect(:user, user)
    else
      flash[:notice] = "Incorrect Password"
      return redirect_to link_accounts_url(user.id)
    end
  end

  def link
    @user = User.find(params[:user_id])
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
      user.email = omniauth['extra'] && omniauth['extra']['user_hash'] && omniauth['extra']['user_hash']['email']
      if user.save
        flash[:notice] = "Successfully registered"
        sign_in_and_redirect(:user, user)
      else
        session[:omniauth] = omniauth.except('extra')
        session[:omniauth_email] = omniauth['extra'] && omniauth['extra']['user_hash'] && omniauth['extra']['user_hash']['email']

        # Check if email already taken. If so, ask user to link_accounts
        if user.errors[:email][0] =~ /has already been taken/ # omniauth? TBD
          # fetch the user with this email id!
          user = User.find_by_email(user.email)
          return redirect_to link_accounts_url(user.id)
        end
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
