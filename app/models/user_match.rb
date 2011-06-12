class UserMatch < ActiveRecord::Base
  set_table_name "users_matches"
  belongs_to :user
  belongs_to :match
end
