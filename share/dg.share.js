var elemList = document.getElementsByTagName('dg:share');
var base_url = 'http://mindtalk.com';
var elemCount = elemList.length;
for (var elemIt = 0; elemIt < elemCount; elemIt++) {
    var el = elemList[elemIt];
	el.onclick = function(){
	    var share_url = this.getAttribute('url') || window.location.href;
	    var share_text = this.getAttribute('message');
		var loc = base_url + "/mind?u=" + encodeURIComponent(share_url);
		if (share_text) {
		    loc = loc + '&desc=' + encodeURIComponent(share_text);
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
    	    'line-height:22px;'+
    	    'cursor:pointer;'+
    	    'border:1px solid #5eafde;'+
    	    'border-radius:3px;'+
    	    'background:url("' + base_url + '/img/icon_mindtalk.png") no-repeat white 1px center;';
	el.onmouseover = function(){
	    this.setAttribute('style', base_style +
    	    'background-color:#EDFFFC;'+
    	    'color:#000;');
    };
    el.onmouseout = function(){
	    this.setAttribute('style', base_style +
    	    'background-color:#FFF;'+
    	    'color:#0D8263;');
    };
    el.onmouseout();
}
