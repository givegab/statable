class Group < ActiveRecord::Base
  statable :members_total, after_save: -> { 100 }
  statable :groups_total, after_save: -> { 200 }
end
