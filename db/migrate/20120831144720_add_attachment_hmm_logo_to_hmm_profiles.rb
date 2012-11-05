class AddAttachmentHmmLogoToHmmProfiles < ActiveRecord::Migration
  def self.up
    change_table :hmm_profiles do |t|
      t.has_attached_file :hmm_logo
    end
  end

  def self.down
    drop_attached_file :hmm_profiles, :hmm_logo
  end
end
