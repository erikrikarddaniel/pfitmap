jQuery(function($) {
    $('#protein_menu').bind("ajax:success", function(xhr, data, status) {
	$("#protein_counts_table").html(data);
    });

    $('#expListAjaxProteinCountTable').bind("ajax:success", function(xhr, data, status) {
	$("#protein_counts_table").html(data);
    });

    $('#explanations a').tooltip()
})

$(document).ready(function(){
    // Original from:
    // jQuery Tutorial – Create a Flexible Data Heat Map
    // http://www.designchemical.com/blog/index.php/jquery/
    // /jquery-tutorial-create-a-flexible-data-heat-map/
    //--------------------------------------------------

    // The number of partitions
    n = 100;

    // Define the starting colour (ratio = 0)
    xr = 0;
    xg = 0;
    xb = 255;
 
    // Define the ending colour (ratio = 1)
    yr = 0;
    yg = 255;
    yb = 0;

    $('.heat-map tbody td.heat').each(function(){
	var color_int = this.getAttribute('data-color');

	red =  parseInt((xr + ((color_int * (yr-xr))/(n-1))).toFixed(0));
	green = parseInt((xg + ((color_int * (yg-xg))/(n-1))).toFixed(0));
	blue =  parseInt((xb + ((color_int * (yb-xb))/(n-1))).toFixed(0));
	clr = 'rgb('+red+','+green+','+blue+')';
	$(this).css({backgroundColor:clr});
    });

});
