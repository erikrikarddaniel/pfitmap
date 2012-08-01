$(function proteincounts() { 
    $('taxon_rank_menu').on('click','li', function(event) {
	if(this == event.target) {
	    var rank_name = this.id;
	    $.ajax({
		type : 'GET',
		url : '/protein_counts.js?rank=' + rank_name,
		dataType : 'html',
		success : function(data){
		    $('#protein_count_table').html(data);
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
		    alert('Error!');
		}
	    })
	}
    }
)
});