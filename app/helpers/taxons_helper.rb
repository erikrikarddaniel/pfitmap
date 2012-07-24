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
end


# Returns lists of children nodes recursively.
def list_children(taxons_collection)
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
