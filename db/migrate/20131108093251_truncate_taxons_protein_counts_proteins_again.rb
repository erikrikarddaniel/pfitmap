class TruncateTaxonsProteinCountsProteinsAgain < ActiveRecord::Migration
  def change
    ActiveRecord::Base.connection.execute("TRUNCATE protein_counts, taxons, proteins, enzyme_proteins")
  end
end
