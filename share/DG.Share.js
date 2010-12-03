var elemList = document.getElementsByName('dg_share');
var elemCount = elemList.length;
for (var elemIt = 0; elemIt < elemCount; elemIt++) {
	elemList[elemIt].onclick = function(){
	    var share_url = this.getAttribute('share_url') || window.location.href;
	    var share_text = this.getAttribute('share_message');
		var loc = "http://digaku.com/share?u=" + share_url;
		if (share_text) {
		    loc = loc + '&message=' + share_text;
	    }
		var width = 626;
		var height = 436;
		var centeredY, centeredX;
		centeredY = (screen.height - height)/2;
		centeredX = (screen.width - width)/2;
		var windowParams =  'height=' + height +
							',width=' + width +
							',toolbar=0' +
							',scrollbars=0' +
							',status=0' +
							',resizable=0' +
							',location=' + loc +
							',menuBar=0' +
							',left=' + centeredX +
							',top=' + centeredY;
		window.open(loc, "Digaku Share", windowParams).focus();
		return false;
	};
	elemList[elemIt].setAttribute('style', ''+
	    'font-family:"Lucida Grande",Verdana,sans-serif;'+
	    'font-size:10px;'+
	    'font-weight:normal;'+
	    'text-decoration:none;'+
	    'background-color:#5eafde;'+
	    'color:#fffbe2;'+
	    'padding:4px;'+
	    'line-height:21px;'+
	    'cursor:hand;'
	    );
}
