class CreateRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :records do |t|
      t.string :name
      t.string :record_type
      t.string :record_data
      t.integer :ttl
      t.references :zone, foreign_key: true

      t.timestamps
    end
  end
end
