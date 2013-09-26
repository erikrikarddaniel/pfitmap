jQuery(function($) {
    $('#protein_menu').bind("ajax:success", function(xhr, data, status) {
	$("#protein_counts_table").html(data);
    });
    
    $('#expListAjaxProteinCountTable').bind("ajax:success", function(xhr, data, status) {
	$("#protein_counts_table").html(data);
    });

    $('#widentable').unbind('click').click(function(event) {
	$('div.heat-map').toggleClass('wide');
    });
})
// Following two functions are taken from 
// http://www.linuxtopia.org/online_books/javascript_guides/javascript_faq/rgbtohex.htm
// copyright Alexei Kourbatov
function RGBtoHex(R,G,B) {return toHex(R)+toHex(G)+toHex(B)}
function toHex(N) {
    if (N==null) return "00";
    N=parseInt(N); if (N==0 || isNaN(N)) return "00";
    N=Math.max(0,N); N=Math.min(N,255); N=Math.round(N);
    return "0123456789ABCDEF".charAt((N-N%16)/16)
	+ "0123456789ABCDEF".charAt(N%16);
}

$(document).ready(function(){
//    colorHeatmap();
//    IndentTaxons();
//    initTips();
    d3_table_it(gon.taxons_proteins_protein_counts,gon.columns);
});

function initTips(){
    $('#explanations a').tooltip();
    $('td.heat a').tooltip();
    $('td.taxon a.name').tooltip();
}

function colorHeatmap(){
    // Original from:
    // jQuery Tutorial – Create a Flexible Data Heat Map
    // http://www.designchemical.com/blog/index.php/jquery/
    // /jquery-tutorial-create-a-flexible-data-heat-map/
    //--------------------------------------------------

    // The number of partitions
    n = 100;

    // Define the starting colour (ratio = 0)
    xr = 255;
    xg = 255;
    xb = 0;
 
    // Define the ending colour (ratio = 1)
    yr = 255;
    yg = 0;
    yb = 0;

    $('.heat-map tbody td.heat').each(function(){
	var color_int = this.getAttribute('data-color');
	if (color_int == 0)
	{
	    red = 255;
	    green = 255;
	    blue = 255;
	}
	else
	{
	    red =  parseInt((xr + ((color_int * (yr-xr))/(n-1))).toFixed(0));
	    green = parseInt((xg + ((color_int * (yg-xg))/(n-1))).toFixed(0));
	    blue =  parseInt((xb + ((color_int * (yb-xb))/(n-1))).toFixed(0));
	}
	hex_clr = RGBtoHex(red,green,blue);
	hex_clr2 = '#' + hex_clr;
	$(this).css({backgroundColor: hex_clr2});
    });

};

function IndentTaxons() {
    $('.heat-map tbody td.taxon').each(function(){
	var indent_int = this.getAttribute('data-indent');
	var indent_magnitude = indent_int*10
	$(this).css({textIndent: indent_magnitude});
    });
}
function d3_table_it(dataset,columns) {
    d3.select("#heat_map").select("table").remove();
    var table = d3.select("#heat_map")
        .append("table")
        .attr("class","rnr_table");
    
    var thead = table.append("thead");
    var tbody = table.append("tbody");
    
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
