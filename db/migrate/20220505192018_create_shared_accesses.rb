class CreateSharedAccesses < ActiveRecord::Migration[7.0]
  def change
    create_table :shared_accesses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
