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
end
