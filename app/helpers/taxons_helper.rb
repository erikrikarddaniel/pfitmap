module TaxonsHelper
  # Returns lists of children nodes recursively.
  def list_taxon_children(taxons_collection)
    html_var = ""
    taxons_collection.each do |t|
      if t.children.any?
        html_var << "<li class='collapsed'><i class='icon-plus' id='expand_#{t.id}'> </i>" << link_to(t.name, t) << "<ul style='display: none'> </ul>"
      else
        html_var << "<li><i class='icon-white' style='visibility: hidden;'> </i>" << link_to(t.name, t)
      end
      html_var <<  "</li>\n"
    end
    return html_var.html_safe
  end

  # Same as above, but with ajax-links to govern the protein_counts table at
  # /protein_counts_by_hierarchy
  def list_taxon_children_protein_counts(taxons_collection)
    html_var = ""
    taxons_collection.each do |t|
      if t.children.any?
        html_var << "<li class='collapsed'><i class='icon-plus' id='expand_#{t.id}'> </i>" << link_to(t.name, protein_counts_by_hierarchy_path(parent_taxon_id: t.id), remote: true) << "<ul style='display: none'> </ul>"
      else
        html_var << "<li><i class='icon-white' style='visibility: hidden;'> </i>" << link_to(t.name, protein_counts_by_hierarchy_path(parent_taxon_id: t.id), remote: true)
      end
      html_var <<  "</li>\n"
    end
    return html_var.html_safe
  end
end


# Returns lists of children nodes recursively.
def list_children(taxons_collection)
  taxons_collection.sort_by {|p| p.hierarchy}
  html_var = ""
  taxons_collection.each do |t|
    if not t.children.empty?
      html_var << "<li><i class='icon-plus'> </i>" << link_to(t.name, t) << "<ul>" << list_children(t.children) << "</ul>"
    else
      html_var << "<li><i class='icon-white' style='visibility: hidden;'> </i>" << link_to(t.name, t)
    end
    html_var <<  "</li>\n"
  end
  return html_var.html_safe
end
