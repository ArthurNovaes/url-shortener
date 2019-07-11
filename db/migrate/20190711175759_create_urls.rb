class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.text :original
      t.string :short
      t.string :sanitize

      t.timestamps
    end
  end
end
