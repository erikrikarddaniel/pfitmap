$(function prepareList() {
    $('#expListAjax li:has(ul)').on('click', 'i', function(event) {
	if(this == event.target) {
	    $(this).toggleClass('icon-plus')
	    $(this).toggleClass('icon-minus')
	    $(this).parent().toggleClass('expanded');
	    var taxon_expand_id = this.id;
	    var taxon_id = taxon_expand_id.slice(7);
	    if($(this).parent().children('ul:has(li)').length > 0)
	       {
		   $(this).parent().children('ul').toggle();
	       }
	       else {
		   $(this).parent().children('ul').load('/taxons/' + taxon_id + '/ajax_list.js').show();
	       }
	}
	return false;
    });
});