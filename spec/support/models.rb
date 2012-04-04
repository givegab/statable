class GroupMembership < ActiveRecord::Base
  belongs_to :groupable, polymorphic: true
  belongs_to :group
end

class User < ActiveRecord::Base
  has_many :group_memberships, as: :groupable
end

class Group < ActiveRecord::Base

  statable :counter, :staff_total, { callbacks: {after_save: -> { +1 }, after_destroy: -> { -1 }}, scope: GroupMembership }
  statable :counter, :users_total, after_save: -> { -1 }
  statable :counter, :members_total, after_save: -> { 1 }
  statable :value, :groups_total, after_save: -> { 200 + 100 + 800 }

  has_many :group_memberships

  has_many :members,
           through: :group_memberships,
           source: :groupable,
           source_type: "User",
           select: 'users.*, group_memberships.membership_type',
           order: "users.last_name"
end
