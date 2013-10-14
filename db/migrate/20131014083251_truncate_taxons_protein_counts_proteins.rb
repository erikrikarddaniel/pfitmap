class TruncateTaxonsProteinCountsProteins < ActiveRecord::Migration
  def change
    ActiveRecord::Base.connection.execute("TRUNCATE taxons")
    ActiveRecord::Base.connection.execute("TRUNCATE protein_counts")
    ActiveRecord::Base.connection.execute("TRUNCATE proteins")
  end
end
