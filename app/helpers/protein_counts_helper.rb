module ProteinCountsHelper
#  def protein_counts_params(added_param, before_params)
#    #reset pagination between requests
#    before_params.delete(:page)
#    #Iterate over a single added param:
#    added_param.each do |key, value|
#      if value
#        if before_params[key] == value
#          before_params.delete(key)
#        else
#          before_params[key] = value
#        end
#      else
#        before_params.delete(key)
#      end
#    end
#    return before_params
#  end
#    
#  def protein_counts_array_params(added_param, before_params)
#    #Iterate over a single added param:
#    added_param.each do |key, value|
#      plur_key = (key.to_s + 's').to_sym
#      if value
#        before_values = (before_params[plur_key] ? before_params[plur_key] : [])
#        # Remove intersection, enable inactivation
#        val_arr = [value.to_s]
#        before_params[plur_key] = ((before_values | val_arr) - (val_arr & before_values))
#      else
#        before_params[plur_key] = nil
#      end
#    end
#    return before_params
#  end
#  
#  def pc_col(pc)
#    # Defines a color intensity in the interval (0,100)
#    a = pc.no_genomes_with_proteins
#    b = pc.no_genomes
#    color_ratio = Float(a)/b
#    if (color_ratio > 0.0) && (color_ratio < 0.01)
#      color_int = 1
#    else
#      color_int = Integer(100*color_ratio)
#    end
#  end
#
#  def row_id(taxon)
#    base="taxon#{taxon.id}"
#  end
#
#  def taxon_sign(taxon)
#    if taxon.children.count == 0
#      "-"
#    else
#      "+"
#    end
#  end
#
#  def enzyme_sign(enzyme, enzyme_tree)
#    if (enzyme_tree[enzyme.id][1] == []) and 
#        (enzyme.children.count != 0)
#      "+"
#    else
#      "-"
#    end
#  end
#
#  def no_columns(id, tree)
#    children = tree[id][1]
#    arr = children.map { |c_id| no_columns(c_id,tree) }
#    if arr == []
#      tree[id][0].proteins.count
#    else
#      sum(arr)
#    end
#  end
#
#  def no_genomes_for_taxon(pc_hash, taxon)
#    pc_hash[taxon.id].values.find { |pc| pc }.no_genomes
#  end
#
#  def enzyme_array_expand(expand_enzyme, enzyme_ids)
#    new_enzyme_ids = expand_enzyme.children.map { |e| e.id }
#    enzyme_ids +  new_enzyme_ids
#  end
#
#  def enzyme_array_collapse(collapse_enzyme, enzyme_ids)
#    remove_enzyme_ids = collapse_enzyme.children.map { |e| e.id }
#    if remove_enzyme_ids == []
#      enzyme_ids
#    else
#      enzyme_ids - remove_enzyme_ids
#    end
#  end
#
#  def link_to_collapse(parent_taxon, enzyme_ids, level)
#    link_to "-", { :controller => "protein_counts", :action => "collapse_rows", :parent_id => parent_taxon.id, :level => (level-1), :enzyme_ids => enzyme_ids}, :remote => true
#  end
#
#  def link_to_expand(sign, parent_taxon, enzyme_ids, level)
#    link_to sign , { :controller => "protein_counts", :action => "add_row", :parent_id => parent_taxon.id, :level => level, :enzyme_ids => enzyme_ids}, :remote => true
#  end
#
#  private
#  def sum(arr)
#    arr.inject{|s,x| s + x }
#  end
end
