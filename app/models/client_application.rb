class ClientApplication < ActiveRecord::Base
  belongs_to :user

  def self.authenticate(app_id, app_secret)
    where(["app_id = ? AND app_secret = ?", app_id, app_secret]).first
  end
end