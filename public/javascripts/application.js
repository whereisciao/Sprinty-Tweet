// generic enumeration
Function.prototype.forEach = function(object, block, context) {
  for (var key in object) {
    if (typeof this.prototype[key] == "undefined") {
      block.call(context, object[key], key, object);
    }
  }
};

// globally resolve forEach enumeration
var forEach = function(object, block, context) {
  if (object) {
    var resolve = Object; // default
    if (object instanceof Function) {
      // functions have a "length" property
      resolve = Function;
    } else if (object.forEach instanceof Function) {
      // the object implements a custom forEach method so use that
      object.forEach(block, context);
      return;
    } else if (typeof object.length == "number") {
      // the object is array-like
      resolve = Array;
    }
    resolve.forEach(object, block, context);
  }
};

jQuery.extend(String.prototype, {
  databaseId: function() { return $.trim(this.split('_').last()); }
});

jQuery.extend(Array.prototype, {
  last: function() { return this[this.length-1]; }
});

jQuery.authenticity_token = function() {
  return $('#authenticity_token').attr('content');
};

function log() {
  if (window && window.console && window.console.log)
    for(var i=0, len=arguments.length; i<len; i++)
      console.log(arguments[i]);
};

jQuery(function($) {
  var countdown = $('#countdown');
  var allowed = parseInt(countdown.text());
  $('#text').keydown(function() {
    var length = $(this).val().length;
    countdown.text(allowed - length);
    
    if (length == 0) {
      $('#in_reply_to_status_id').val('');
      var label = $('div#update label[for=text]')
      label.text(label.data('original_text'));
    }
  });
  
  $('a.dm').click(function() {
    window.scrollTo(0, 0);
    $('#text').focus().val('d ' + $(this).attr('rel') + ' ');
    return false;
  });
  
  var label = $('div#update label[for=text]')
  label.data('original_text', label.text());
  
  $('a.reply').click(function() {
    window.scrollTo(0, 0);
    var pieces = $(this).attr('rel').split(':');
    var screen_name = pieces[0];
    var id = pieces[1];
    $('#text').focus().val('@' + screen_name + ' ');
    $('#in_reply_to_status_id').val(id);
    $('div#update label[for=text]').text('Replying to ' + screen_name + "'s tweet #" + id);
    return false;
  });
	
	$('#mash_apiKey').change(function(){
		console.debug("change");
		var apiKey = $(this).val();		
		var callback = function(data){
			$("#spinner").toggle();
			if(data.phone != undefined && data.phone.length > 0){
				$("#mash_mdn").empty();
				$.each(data.phone,function(idx, val){
					console.debug("\t" + idx + " " + val);
					var optionStr = []
					optionStr.push("<option value=\""+val+"\">&nbsp;");
					optionStr.push(val.substr(0,3) + "-");
					optionStr.push(val.substr(3,3) + "-");
					optionStr.push(val.substr(6,4));
					optionStr.push("</option>");
					$("#mash_mdn").append(optionStr.join(""));
				});
			}							
		}
		if(apiKey != undefined && apiKey.length >= 15){
			// Loading Phone List    
			console.debug("Loading Phone List");	
			$("#spinner").toggle();
			$.getJSON("/get_phone_list", {key: apiKey}, callback);
		}		
	});
});