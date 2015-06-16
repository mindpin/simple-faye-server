(function() {
  var info, process, search;

  info = {
    chanel: "/foo",
    username: "fushang318"
  };

  search = window.location.search;

  jQuery.each(search.replace("?", "").split("&"), function(i, str) {
    var arr, key, value;
    arr = str.split("=");
    key = arr[0];
    value = arr[1];
    if (key === "username") {
      info.username = value;
    }
    if (key === "chanel") {
      return info.chanel = "/" + value;
    }
  });

  process = {
    client: new Faye.Client('http://faye.4ye.me:9527/faye'),
    send_message: function() {
      var message, pub;
      message = jQuery("input[name='message']").val();
      message = message.replace(/(^\s*)|(\s*$)/g, '');
      if (message === void 0 || message.length === 0) {
        return;
      }
      pub = process.client.publish(info.chanel, {
        text: message,
        username: info.username
      });
      jQuery("input[name='message']").val("");
      return pub.then(null, function() {
        return alert('There was a problem: ' + error.message);
      });
    },
    add_message_to_list: function(data) {
      var $li, $list, text, username;
      username = data.username;
      text = data.text;
      $list = jQuery(".message-list ul");
      if (username === info.username) {
        $li = jQuery("<li class='clearfix self'> <div class='username'>" + username + "</div> <div class='message'>" + text + "</div> </li>");
      } else {
        $li = jQuery("<li class='clearfix other'> <div class='username'>" + username + "</div> <div class='message'>" + text + "</div> </li>");
      }
      $list.append($li);
      return jQuery(".message-list ul").scrollTop(jQuery(".message-list ul")[0].scrollHeight);
    }
  };

  process.client.subscribe(info.chanel, function(data) {
    return process.add_message_to_list(data);
  });

  jQuery(function() {
    jQuery("input[name='message']").on('keydown', function(evt) {
      if (evt.keyCode === 13) {
        return process.send_message();
      }
    });
    return jQuery("button.send").on('click', function() {
      return process.send_message();
    });
  });

}).call(this);
