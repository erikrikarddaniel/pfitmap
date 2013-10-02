$(document).ready(function(){
    d3_table_it(gon.taxon_genomes_counts,gon.columns);
});

function initTips(){
    $('#explanations a').tooltip();
    $('td.heat a').tooltip();
    $('td.taxon a.name').tooltip();
}

function d3_table_it(dataset,columns) {

    d3.select("#heat_map").select("table").remove();
    var table = d3.select("#heat_map")
        .append("table")
        .attr("class","rnr_table");
    
    var thead = table.append("thead");
    var tbody = table.append("tbody");
    
    var head = thead.append("tr").selectAll("td")
        .data(columns)
        .enter()
        .append("td")
        .text(function(d) {return d} );


    var rows = tbody.selectAll("tr")
        .data(dataset)
        .enter()
        .append("tr");
    
    var cells = rows.selectAll("td")
        .data(function(row) {
          return columns.map( function(column) {
            return {column: column, value: row[column]} 
          })
        })
        .enter()
        .append("td")
        .text(function(d) {return d.value } );
}
