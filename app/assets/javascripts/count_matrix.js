$(document).ready(function(){
  if (typeof gon != typeof undefined) {
    d3_make_table();
  }
});

function d3_make_table() {
  d3.select("#heat_map").select("table").remove();
  d3_prep_dataset();
  d3_table_it(gon.taxons);
}
function d3_prep_dataset(){
  gon.dataset = JSON.parse(gon.cm);
  gon.taxons = gon.dataset.taxons;
  gon.taxa_color = d3.scale.category20();
  gon.heat_color = d3.scale.linear().domain([0, 0.5, 1]).range(["white", "yellow", "red"]);
}
function d3_color_table(level) {
  var cells = d3.select("#heat_map").select("table").select("tbody").selectAll("tr").selectAll("td");
  cells.style("background-color",function(d) {if (d.hasOwnProperty("ratio")){return gon.heat_color(d.ratio)}  })

  var tr = d3.selectAll(".taxon_label").style("background-color",function(d) {return gon.taxa_color(d[level]);} ) 
}

function d3_taxon_level(level) {

  params = getParameters();
  params["taxon_level"] = level;
  console.log(gon.taxon_levels);
  for (var i = gon.tl.indexOf(level) + 1; i < gon.tl.length; i++) {delete params[gon.tl[i]];}
  window.location.search = $.param(params);
}

function d3_protein_level(level) {
  params = getParameters();
  params["protein_level"] = level;
  for (var i = gon.pl.indexOf(level) + 1; i < gon.pl.length; i++) {delete params[gon.pl[i]];}
  window.location.search = $.param(params);
}

function d3_filter_table(filter) {
  params = getParameters();
  
  if (filter == "f_proteins_taxa") {
    var pfilter = d3.selectAll("input[name=prot_filter]:checked")[0];
    var tfilter = d3.selectAll("input[name=tax_filter]:checked")[0];
    var p = pfilter.map(function(d) {return d.value});
    var t = tfilter.map(function(d) {return d.value});
    if (p.length > 0) { 
      params[gon.dataset.protein_level] = p.join("(,)");
    }
    if (t.length > 0) {
      params[gon.dataset.taxon_level] = t.join("(,)");
    }
  }
  else 
  {  
    if (filter == "clear_proteins" || filter == "clear_all")
    {
      gon.protein_levels.forEach(function(l) {
        delete params[l];
      });
    }
    if (filter == "clear_taxa" || filter == "clear_all")
    {
      gon.taxon_levels.forEach(function(l) {
        delete params[l];
      });
    }
  }
  window.location.search = $.param(params);
}


function d3_table_it(dataset) {
    var table = d3.select("#heat_map")
        .append("table")
        .attr("class","count_matrix");
    
    var thead = table.append("thead");
    var tbody = table.append("tbody");
    
    var head = thead.append("tr").selectAll("td")
        .data(gon.columns)
        .enter()
        .append("td")
        .attr("class", function(d) { if(gon.prot_columns.indexOf(d) != -1) {return "protein_label";} else {return null;} } )
        .text(function(d) {return gon.prot_columns.indexOf(d) == -1 ? gon.column_names[d] : null} )

    var plabel = d3.selectAll(".protein_label")
        plabel.append("input").attr("type","checkbox").attr("name","prot_filter").attr("value",function(d) {return d})
        plabel.append("span").attr("class","input-group-addon").text(function(d) {return d})

    var rows = tbody.selectAll("tr")
        .data(dataset)
        .enter()
        .append("tr")
        .attr("class",function(d) {return d.domain })

    var cells = rows.selectAll("td")
        .data(function(row) { 
          //create dictionary of proteins for each row:
          var proteins = row.proteins.reduce( function(obj,x) {
              obj[x[gon.dataset.protein_level]] = {no_proteins: x.no_proteins,ratio: x.no_genomes_with_proteins / row.no_genomes, no_genomes_with_proteins: x.no_genomes_with_proteins} ;
              return obj;
          },{});
          //mapping and joining on the columns in the header
          return gon.tax_columns.map( function(column) {
            return {column: column, value: row[column]}
          })
          .concat(
            gon.prot_columns.map(function(column) { 
              p = proteins[column];
              return {column: column, value: p ? p.no_proteins : 0, ratio: p ? p.ratio : 0, organism: row[gon.dataset.taxon_level], no_genomes_with_proteins: p ? p.no_genomes_with_proteins : 0 }
            })
          )
        })
        .enter()
        .append("td")
        .attr("class",function(d){ return d.hasOwnProperty("organism") ? "heat_label " + d.column : null })
        .text(function(d) {if (d.column != gon.dataset.taxon_level) {return d.value} } );

    var tlabel = rows.select("td").attr("class","taxon_label")
        tlabel.append("input").attr("type","checkbox").attr("name","tax_filter").attr("value",function(d) {return d[gon.dataset.taxon_level]})
        tlabel.append("span").attr("class","input-group-addon").text(function(d) {return d[gon.dataset.taxon_level]})
    //taxon tooltip
    $(".taxon_label").tooltip({"toggle":true,"title":function () {r=[];for (var i = 0; i < gon.taxon_levels.length-1; i++) {r.push(this.__data__[gon.taxon_levels[i]])};return r.join("\\")},"placement":"left"});
    //cell tooltip
    $(".heat_label").tooltip({"toggle":true,"title":function() {return "Proteins: "+this.__data__.value+" Genomes w. proteins: "+this.__data__.no_genomes_with_proteins+" Organism: " + this.__data__.organism + " Protein: "+this.__data__.column} })
    d3_color_table(gon.taxon_levels[0]);
}

function updateQueryStringParameter(uri, key, value) {
  var re = new RegExp("([?|&])" + key + "=.*?(&|$)", "i");
  separator = uri.indexOf('?') !== -1 ? "&" : "?";
  if (uri.match(re)) {
    return uri.replace(re, '$1' + key + "=" + value + '$2');
  }
  else {
    return uri + separator + key + "=" + value;
  }
}
function getParameters() {
  var searchString = window.location.search.substring(1)
    , params = searchString.split("&")
    , hash = {}
    ;

  if (searchString == "") return {};
  for (var i = 0; i < params.length; i++) {
    var val = params[i].split("=");
    hash[unescape(val[0])] = unescape(val[1]);
  }
  return hash;
}
