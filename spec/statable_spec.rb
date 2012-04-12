require 'spec_helper'

describe "statable" do
  describe "object with counter type" do
    group = Group.create(name: "group 1")

    it "should set value" do
      group.save
      group.groups_total.value.should == "1100"
    end

  end

  describe "scope" do
    group = Group.create(name: "group 2")
    user = User.create(name: "Bob")

    it "should execute callback in the context of scope" do

      gm1 = GroupMembership.new(groupable: user, membership_type: "Staff")
      gm2 = GroupMembership.new(groupable: user, membership_type: "Faculty")

      group.group_memberships << gm1
      group.staff_members.value.should == 1
      group.student_members.value.should == 0
      group.alumni_members.value.should == 0
      group.faculty_members.value.should == 0

      group.group_memberships << gm2
      group.staff_members.value.should == 1
      group.student_members.value.should == 0
      group.alumni_members.value.should == 0
      group.faculty_members.value.should == 1

      gm2.destroy
      group.staff_members.value.should == 1
      group.student_members.value.should == 0
      group.alumni_members.value.should == 0
      group.faculty_members.value.should == 0
    end
  end
end
