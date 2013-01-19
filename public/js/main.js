$(document).ready(function() {
	var ENTER_KEY = 13;
	
	var reload = function() { location.reload(true); };
	
	$("#new-todo").keypress(function() {
		if (event.which == ENTER_KEY) {
			$.ajax ({
			    type: "POST",				
			    url: "/",
			    data: JSON.stringify({ text: $(this).val() }),
			    contentType: "application/json; charset=utf-8",
				complete: reload
			});
	    }
	});
	
	$(".toggle").click(function() {
		var id = $(this).parents('li').attr('id');
		var isDone = $(this).is(':checked');
		$.ajax ({
		    type: "PUT",			
		    url: "/" + id,
		    data: JSON.stringify({ done: isDone }),
		    contentType: "application/json; charset=utf-8",
			complete: reload
		});
	});	
	

	$(".destroy").click(function() {
		var id = $(this).parents('li').attr('id');
		$.ajax ({
		    type: "DELETE",			
		    url: "/" + id,
			complete: reload
		});
	});
});