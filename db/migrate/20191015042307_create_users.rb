class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.date :date_joined

      t.timestamps
    end
  end
end
