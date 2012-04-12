ActiveRecord::Schema.define do
  self.verbose = false

  create_table :groups, :force => true do |t|
    t.string :name
    t.string :description
    t.timestamps
  end

  create_table :group_memberships, :force => true  do |t|
    t.integer :group_id, null: false
    t.integer :groupable_id, null: false
    t.string  :groupable_type, limit: 20
    t.string  :membership_type

    t.timestamps
  end

  create_table :users, :force => true  do |t|
    t.string :name
    t.timestamps
  end
end

