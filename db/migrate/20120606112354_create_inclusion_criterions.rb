class CreateInclusionCriterions < ActiveRecord::Migration
  def change
    create_table :inclusion_criterions do |t|

      t.timestamps
    end
  end
end
