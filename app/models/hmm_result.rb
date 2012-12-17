# == Schema Information
#
# Table name: hmm_results
#
#  id                 :integer         not null, primary key
#  executed           :datetime
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  hmm_profile_id     :integer
#  sequence_source_id :integer         not null
#

class HmmResult < ActiveRecord::Base
  MAX_HISTO_CLASS_SIZE = 50
  MIN_N_HISTO_CLASSES = 10
  attr_accessible :sequence_source_id, :executed
  belongs_to :sequence_source
  belongs_to :hmm_profile
  has_many :hmm_result_rows, :dependent => :destroy
  validates :hmm_profile_id, presence: true
  validates :sequence_source_id, presence: true
  validates :hmm_profile_id, :uniqueness => { :scope => :sequence_source_id, :message => "Only one result per combination of HMM Profile and Sequence database!" }

  def to_s
    "HmmResult: #{hmm_profile}-#{sequence_source} #{executed}"
  end

   # http://code.google.com/apis/chart/interactive/docs/gallery/barchart.html#Example
  def create_histogram
    max_score = hmm_result_rows.maximum("fullseq_score")
    bin_size,n_bins = bin_size_and_count(max_score)
    histogram_hash = group_counts(bin_size)
    rows = []
    histogram_hash.each_pair do |divisor, n|
      rows << ["#{divisor*bin_size}-#{divisor*bin_size+bin_size-1}",n]
    end
    data_table = GoogleVisualr::DataTable.new
    data_table.new_columns([{type: 'string', label: 'Year'},{type: 'number', label: 'No Sequences'}])
    data_table.add_rows(rows)

    opts   = { :width => 600, 
      :height => 240, 
      :title => 'HMM Score Histogram',
      :colors => ['blue'],
      :legend => {position: 'none'},
      :bar => {groupWidth:"99%"},
      :hAxis => {slantedText: "true"}
      }
    chart = GoogleVisualr::Interactive::ColumnChart.new(data_table, opts)
  end

  def group_counts(bin_size)
    histogram_hash = {} 
    scores = hmm_result_rows.select("fullseq_score").map { |r| r.fullseq_score }
    scores.group_by { |f| f.to_i/bin_size }.map{ |k,a| histogram_hash[k] = a.count }
    return histogram_hash
  end

  def bin_size_and_count(max_score)
    bin_size = MAX_HISTO_CLASS_SIZE
    while (Integer(max_score)/bin_size) <= MIN_N_HISTO_CLASSES
      bin_size += 10
    end
    no_bins = (Integer(max_score)/bin_size)
    return bin_size, no_bins
  end
end
