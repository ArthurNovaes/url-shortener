class CreateHits < ActiveRecord::Migration[5.2]
  def change
    create_table :hits do |t|
      t.references :url, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
