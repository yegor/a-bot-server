class CreateUsersUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false, default: ""
    end
  end
end