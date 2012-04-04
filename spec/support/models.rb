class GroupMembership < ActiveRecord::Base
  belongs_to :groupable, polymorphic: true
  belongs_to :group
end

class User < ActiveRecord::Base
  has_many :group_memberships, as: :groupable
end

class Group < ActiveRecord::Base

  statable :student_members,
          scope: GroupMembership,
          callbacks: {after_save: 1, after_destroy: -1},
          conditions: {membership_type: "Student"}

  statable :alumni_members,
          scope: GroupMembership,
          callbacks: {after_save: 1, after_destroy: -1},
          conditions: {membership_type: "Alumni"}

  statable :faculty_members,
          scope: GroupMembership,
          callbacks: {after_save: 1, after_destroy: -1},
          conditions: {membership_type: "Faculty"}

  statable :staff_members,
          scope: GroupMembership,
          callbacks: {after_save: 1, after_destroy: -1},
          conditions: {membership_type: "Staff"}

  statable :groups_total, callbacks: { after_save: 200 + 100 + 800 }, type: :value

  has_many :group_memberships

  has_many :members,
           through: :group_memberships,
           source: :groupable,
           source_type: "User",
           select: 'users.*, group_memberships.membership_type',
           order: "users.last_name"
end
