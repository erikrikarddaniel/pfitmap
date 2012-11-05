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
    #max = 255
    n=100

    a = pc.no_genomes_with_proteins
    b = pc.no_genomes
    color_int = (a*255)/b    

    # Define the ending colour, which is white
    xr = 255
    xg = 255
    xb = 255
 
    # Define the starting colour #f32075
    yr = 243
    yg = 32
    yb = 117

    red =   xr + (color_int * (yr-xr))/(n-1)
    green = xb + (color_int * (yb-xb))/(n-1)
    blue =  xg + (color_int * (yg-xg))/(n-1)
    
    "rgb(#{red},#{green},#{blue})"
  end
end
