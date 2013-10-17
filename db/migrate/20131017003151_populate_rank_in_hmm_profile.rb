class PopulateRankInHmmProfile < ActiveRecord::Migration
  def up
    tl = Protein::PROT_LEVELS
    prev_parents = nil
    tl.each do |t|
      HmmProfile.where(parent_id: prev_parents).update_all(rank: t)
      prev_parents =  HmmProfile.where(parent_id: prev_parents).map{|p| p.id}
    end
  end

  def down
    HmmProfile.update_all(rank: nil)
  end
end
