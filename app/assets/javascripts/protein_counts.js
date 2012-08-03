jQuery(function($) {
    $('#protein_menu').bind("ajax:success", function(xhr, data, status) {
	$("#protein_counts_table").html(data);
    });

    $('#expListAjaxProteinCountTable').bind("ajax:success", function(xhr, data, status) {
	$("#protein_counts_table").html(data);
    });

    $('#explanations a').tooltip()
})