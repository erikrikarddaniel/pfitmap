$(function prepareList() {
    $('#expList li:has(ul)').find('i').unbind('click').click(function(event) {
	if(this == event.target) {
	    $(this).toggleClass('icon-plus')
	    $(this).toggleClass('icon-minus')
	    $(this).parent().toggleClass('expanded');
	    $(this).parent().children('ul').toggle('medium');
	}
	return false;
    }).parent().addClass('collapsed').removeClass('expanded').children('ul').hide();


    
    //Hack to add links inside the cv
    $('#expList a').unbind('click').click(function() {
	window.open($(this).attr('href'), "_self");
	return false;
    });
    //Create the button functionality
    $('#expandList').unbind('click').click(function() {
	$('.collapsed').addClass('expanded');
	$('.collapsed').children().show('medium');
    })
    $('#collapseList').unbind('click').click(function() {
	$('.collapsed').removeClass('expanded');
	$('.collapsed').children().hide('medium');
    })
});

$