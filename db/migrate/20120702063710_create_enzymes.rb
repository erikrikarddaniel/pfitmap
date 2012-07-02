class CreateEnzymes < ActiveRecord::Migration
  def change
    create_table :enzymes do |t|
      t.string :name

      t.timestamps
    end
  end
end
