class CreateFriend < ActiveRecord::Migration[6.0]
  def change
    create_table :friends do |t|
      t.belongs_to :user
      t.string :name, null: false
      t.string :email, null: false
      t.text :description
    end
  end
end
