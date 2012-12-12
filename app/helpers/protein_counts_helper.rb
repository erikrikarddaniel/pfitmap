module ProteinCountsHelper
  def protein_counts_params(added_param, before_params)
    #reset pagination between requests
    before_params.delete(:page)
    #Iterate over a single added param:
    added_param.each do |key, value|
      if value
        if before_params[key] == value
          before_params.delete(key)
        else
          before_params[key] = value
        end
      else
        before_params.delete(key)
      end
    end
    return before_params
  end
    
  def protein_counts_array_params(added_param, before_params)
    #Iterate over a single added param:
    added_param.each do |key, value|
      plur_key = (key.to_s + 's').to_sym
      if value
        before_values = (before_params[plur_key] ? before_params[plur_key] : [])
        # Remove intersection, enable inactivation
        val_arr = [value.to_s]
        before_params[plur_key] = ((before_values | val_arr) - (val_arr & before_values))
      else
        before_params[plur_key] = nil
      end
    end
    return before_params
  end
  
  def pc_col(pc)
    # Defines a color intensity in the interval (0,100)
    a = pc.no_genomes_with_proteins
    b = pc.no_genomes
    color_ratio = Float(a)/b
    if (color_ratio > 0.0) && (color_ratio < 0.01)
      color_int = 1
    else
      color_int = Integer(100*color_ratio)
    end
  end

  def row_id(taxon)
    base="taxon#{taxon.id}"
  end

  def taxon_sign(taxon)
    if taxon.children.count == 0
      "-"
    else
      "+"
    end
  end

  def enzyme_sign(enzyme, enzyme_tree)
    if (enzyme_tree[enzyme.id][1] == []) and 
        (enzyme.children.count != 0)
      "+"
    else
      "-"
    end
  end

  def no_columns(id, tree)
    children = tree[id][1]
    arr = children.map { |c_id| no_columns(c_id,tree) }
    if arr == []
      tree[id][0].proteins.count
    else
      sum(arr)
    end
  end

  def enzyme_array_expand(expand_enzyme, enzyme_ids)
    new_enzyme_ids = expand_enzyme.children.map { |e| e.id }
    enzyme_ids +  new_enzyme_ids
  end

  def enzyme_array_collapse(collapse_enzyme, enzyme_ids)
    remove_enzyme_ids = collapse_enzyme.children.map { |e| e.id }
    enzyme_ids - remove_enzyme_ids
  end

  private
  def sum(arr)
    arr.inject{|s,x| s + x }
  end
end
