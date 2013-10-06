$(document).ready(function(){
    d3_prep_dataset();
    d3_table_it(gon.taxons);
});

function d3_prep_dataset(){
  gon.dataset = JSON.parse(gon.cm);
  gon.taxons = gon.dataset.taxons
}

function d3_table_it(dataset) {
    d3.select("#heat_map").select("table").remove();
    var table = d3.select("#heat_map")
        .append("table")
        .attr("class","rnr_table");
    
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
    
    var cells = rows.selectAll("td")
        .data(function(row) { 
          //create dictionary of proteins for each row:
          var proteins = row.proteins.reduce( 
            function(obj,x) {
              obj[x[gon.dataset.protein_level]] = {no_proteins: x["no_proteins"]}; no_proteins_with_genomes: x["no_proteins_with_genomes"];return obj;},
            {}
          );
          //mapping and joining on the columns in the header
          return gon.tax_columns.map( function(column) {
            return {column: column, value: row[column]}
          }).concat(gon.prot_columns.map(function(column) { p = proteins[column];return {column: column, value: p.no_proteins  }}))
        })
        .enter()
        .append("td")
        .text(function(d) {return d.value } );
}
