class CreateConfigurableParams < ActiveRecord::Migration
  def change
    create_table :configurable_params do |t|
      t.string :param
      t.string :value

      t.timestamps
    end
  end
end
