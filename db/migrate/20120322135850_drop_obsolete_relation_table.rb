class DropObsoleteRelationTable < ActiveRecord::Migration
  def change
    drop_table :result_seq_relations
  end
end
