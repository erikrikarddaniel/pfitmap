module HmmProfilesHelper
  # Returns lists of children nodes recursively.
  def list_children(profile_collection)
    html_var = ""
    profile_collection.each do |p|
      if not p.children.empty?
        html_var << "<li><i class='icon-plus'> </i>" << link_to(p.description, p) << "<ul>" << list_children(p.children) << "</ul>"
      else
        html_var << "<li><i class='icon-white'> </i>" << link_to(p.description, p)
      end
      html_var <<  "</li>\n"
    end
    return html_var.html_safe
  end
end
