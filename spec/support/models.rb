class Group < ActiveRecord::Base
  statable "total", after_save: -> { 5 }
end
