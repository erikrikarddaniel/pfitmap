# == Schema Information
#
# Table name: loadable_dbs
#
#  id               :integer         not null, primary key
#  db               :string(255)
#  common_name      :string(255)
#  genome_sequenced :boolean
#  default          :boolean
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

require 'spec_helper'

describe LoadableDb do
  before do
    @loadable_db = LoadableDb.new(db: 'ref', common_name: 'RefSeq', genome_sequenced: false, default: false)
  end

  subject { @loadable_db }

  it { should be_valid }
  it { should respond_to(:db) }
  it { should respond_to(:common_name) }
  it { should respond_to(:genome_sequenced) }
  it { should respond_to(:default) }
  it { should respond_to(:protein_counts) }

  describe "mandatory fields" do
    it "should not be valid without db" do
      @loadable_db.db = nil
      @loadable_db.should_not be_valid
    end

    it "should not be valid without common_name" do
      @loadable_db.common_name = nil
      @loadable_db.should_not be_valid
    end

    it "should not be valid without genome_sequenced" do
      @loadable_db.genome_sequenced = nil
      @loadable_db.should_not be_valid
    end

    it "should not be valid without default" do
      @loadable_db.default = nil
      @loadable_db.should_not be_valid
    end
  end

  describe "unique fields" do
    before do
      @loadable_db.save
      @copy = LoadableDb.new(db: 'name', common_name: 'Name', genome_sequenced: false, default: false)
    end

    it "shold be valid if db and common_name are different" do
      @copy.should be_valid
    end

    it "should not be valid with a duplicate db field" do
      @copy.db = @loadable_db.db
      @copy.should_not be_valid
    end

    it "should not be valid with a duplicate common_name field" do
      @copy.common_name = @loadable_db.common_name
      @copy.should_not be_valid
    end
  end
end
