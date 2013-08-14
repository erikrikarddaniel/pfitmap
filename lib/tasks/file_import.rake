require 'file_parsers'

DATADIR = 'data'

namespace :file_import do
  desc "Import fasta files with sequences from data/external_dbs"
  task import_fasta: :environment do
    dir = "#{DATADIR}/external_dbs"
    puts "Searching in #{dir} for fasta files to import"
    Dir.open(dir).each do |file|
      next unless file =~ /^[^.].*\.(fasta)|(faa)/
      puts "\tImporting sequences from #{dir}/#{file}"
      FileParsers.import_external_db_fasta(File.new("#{dir}/#{file}"))
      puts "\tDone"
    end
    puts "Done with all imports"
  end
end
