module HmmProfilesHelper
  # Returns lists of children nodes recursively.
  def list_children(profile_collection)
    html_var = ""
    profile_collection.each do |p|
      html_var << "<li>" << p.description
      link_html = "<p>" << link_to(" Browse", p) << "</p>"
      html_var << link_html
      if not p.children.empty?
        html_var << "<ul>" << list_children(p.children) << "</ul>"
      end
      html_var <<  "</li>\n"
    end
    return html_var.html_safe
  end
end
