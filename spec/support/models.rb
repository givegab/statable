class Group < ActiveRecord::Base
  statable :counter, :users_total, after_save: -> { -1 }
  statable :counter, :members_total, after_save: -> { 1 }
  statable :value, :groups_total, after_save: -> { 200 + 100 + 800 }

end
