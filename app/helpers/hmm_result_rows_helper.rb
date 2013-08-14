module HmmResultRowsHelper
  def accepted_css_class(criterium, result_row)
    criterium and result_row.fullseq_score > criterium.min_fullseq_score ? 'accepted' : 'not-accepted'
  end
end
