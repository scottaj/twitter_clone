function loadNewsUpdates(ld, ud, handle) {
    $.post('/update/news', {handle: handle}, function( data ) {                 
        $("#"+ld).remove();
        $("#"+ud).append( data );
    });
};

function loadUserUpdates(ld, ud, handle) {
    $.post('/update/user', {handle: handle}, function( data ) {                 
        $("#"+ld).remove();
        $("#"+ud).append( data );
    });
};

function loadTagUpdates(ld, ud, tag) {
    $.post('/update/tag', {tag: tag}, function( data ) {                 
        $("#"+ld).remove();
        $("#"+ud).append( data );
    });
};

function checkAndUpdate(type, param, updater) {
    $.post('/update/check', {type: type, param: param}, function(data) {
	if(""+data == "t"){
	   updater();
	}
	return 0;
    });
};
