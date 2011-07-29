CreateClient.delete_all
User.delete_all

CreateClient.create(
  :name => "secret",
  :app_id => "demo_id",
  :app_secret => "demo_secret"
)

User.create(
  :username => "demo",
  :password_hash => User.hash_password("password", "salt"),
  :password_salt => "salt",
  :status => "Active",
  :expiration_date => "2020-01-01"
)
