class AddDomainNumToHmmAlignment < ActiveRecord::Migration
  def change
    add_column :hmm_alignments, :domain_num, :integer
  end
end
