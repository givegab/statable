ActiveRecord::Schema.define do
  self.verbose = false

  create_table :groups, :force => true do |t|
    t.string :name
    t.string :description
    t.timestamps
  end
end

