$(document).ready(function(){
  if (typeof gon != typeof undefined) {
    d3_prep_dataset();
    d3_table_it(gon.taxons);
  }
});

function d3_prep_dataset(){
  gon.dataset = JSON.parse(gon.cm);
  gon.taxons = gon.dataset.taxons;
  gon.taxa_color = d3.scale.category20();
  gon.heat_color = d3.scale.linear().domain([0, 0.5, 1]).range(["white", "yellow", "red"]);
}
function d3_color_table(level) {

  var tr = d3.select("#heat_map").select("table").select("tbody").selectAll("tr");
  tr.style("background-color",function(d) {console.log(level);return gon.taxa_color(d[level]);} ) 

  var cells = d3.select("#heat_map").select("table").select("tbody").selectAll("tr").selectAll("td");
  cells.style("background-color",function(d) {if (d.hasOwnProperty("ratio")){return gon.heat_color(d.ratio)}  })
}
function d3_table_it(dataset) {
    d3.select("#heat_map").select("table").remove();
    var table = d3.select("#heat_map")
        .append("table")
        .attr("class","count_matrix");
    
    var thead = table.append("thead");
    var tbody = table.append("tbody");
    
    var head = thead.append("tr").selectAll("td")
        .data(gon.columns)
        .enter()
        .append("td")
        .text(function(d) {return d} );


    var rows = tbody.selectAll("tr")
        .data(dataset)
        .enter()
        .append("tr")
        .attr("class",function(d) {return d.domain })

    var cells = rows.selectAll("td")
        .data(function(row) { 
          //create dictionary of proteins for each row:
          var proteins = row.proteins.reduce( 
            function(obj,x) {
              obj[x[gon.dataset.protein_level]] = {no_proteins: x["no_proteins"],ratio: x["no_genomes_with_proteins"] / row.no_genomes } ;return obj;},
            {}
          );
          //mapping and joining on the columns in the header
          return gon.tax_columns.map( function(column) {
            return {column: column, value: row[column]}
          }).concat(gon.prot_columns.map(function(column) { p = proteins[column];return {column: column, value: p.no_proteins, ratio: p.ratio  }}))
        })
        .enter()
        .append("td")
        .text(function(d) {return d.value } );
    d3_color_table(gon.taxon_levels[0])
}
