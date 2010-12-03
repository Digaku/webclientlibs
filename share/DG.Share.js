var elemList = document.getElementsByName('dg_share');
var elemCount = elemList.length;
for (var elemIt = 0; elemIt < elemCount; elemIt++) {
    var el = elemList[elemIt];
	el.onclick = function(){
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
	var base_style = 'font-family:"Lucida Grande",Verdana,sans-serif;'+
    	    'font-size:10px;'+
    	    'font-weight:normal;'+
    	    'text-decoration:none;'+
    	    'padding:3px 5px 3px 23px;'+
    	    'line-height:21px;'+
    	    'cursor:hand;'+
    	    'border:1px solid #5eafde;'+
    	    'border-radius:3px;'+
    	    'background-image:url(icon.png);'+
    	    'background-position:4px center;'+
    	    'background-repeat:no-repeat;';
	el.onmouseover = function(){
	    this.setAttribute('style', base_style +
    	    'background-color:#5eafde;'+
    	    'color:#fffbe2;');
    };
    el.onmouseout = function(){
	    this.setAttribute('style', base_style +
    	    'background-color:#bae5ff;'+
    	    'color:#5eafde;');
    };
    el.onmouseout();
}
