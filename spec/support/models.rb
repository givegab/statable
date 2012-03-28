class Group < ActiveRecord::Base
  statable :counter, :members_total, after_save: -> { -1 }
  statable :value, :groups_total, after_save: -> { 200 }
end
