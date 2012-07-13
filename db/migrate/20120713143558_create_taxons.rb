class CreateTaxons < ActiveRecord::Migration
  def change
    create_table :taxons do |t|
      t.string :name
      t.string :rank
      t.boolean :wgs

      t.timestamps
    end
  end
end
