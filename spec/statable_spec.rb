require 'spec_helper'

describe "statable" do
  describe "object with counter type" do
    group = Group.create(name: "group 1")

    it "should decrease counter by one" do
      group.save
      group.users_total.value.should == -2
    end

    it "should increase counter by one" do
      group.members_total.value.should == 2
    end

    it "should set value" do
      group.groups_total.value.should == "1100"
    end

  end

  describe "scope" do
    group = Group.create(name: "group 1")
    user = User.create(name: "Bob")

    it "should execute callback in the context of scope" do

      gm = GroupMembership.new(groupable: user, membership_type: "Staff")
      group.group_memberships << gm

    end
  end
end
