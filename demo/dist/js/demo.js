(function() {
  var Chat;

  jQuery.string_strip = function(str) {
    if (str === void 0) {
      return '';
    }
    return str.replace(/(^\s*)|(\s*$)/g, '');
  };

  jQuery.string_blank = function(str) {
    str = jQuery.string_strip(str);
    return str.length === 0;
  };

  Chat = (function() {
    function Chat(username1, chanel1) {
      this.username = username1;
      this.chanel = chanel1;
      this.chanel = "/" + (encodeURI(this.chanel));
      this.client = new Faye.Client('http://faye.4ye.me:9527/faye');
      this.client.subscribe(this.chanel, (function(_this) {
        return function(data) {
          return _this.add_message_to_list(data);
        };
      })(this));
      this._init_event();
    }

    Chat.prototype.send_message = function() {
      var message, pub;
      message = jQuery("input[name='message']").val();
      message = jQuery.string_strip(message);
      if (message.length === 0) {
        return;
      }
      pub = this.client.publish(this.chanel, {
        text: message,
        username: this.username
      });
      jQuery("input[name='message']").val("");
      return pub.then(null, function() {
        return alert('信息发送失败');
      });
    };

    Chat.prototype.add_message_to_list = function(data) {
      var $li, $list, text, username;
      username = data.username;
      text = data.text;
      $list = jQuery(".message-list ul");
      if (username === this.username) {
        $li = jQuery("<li class='clearfix self'> <div class='username'>" + username + "</div> <div class='message'>" + text + "</div> </li>");
      } else {
        $li = jQuery("<li class='clearfix other'> <div class='username'>" + username + "</div> <div class='message'>" + text + "</div> </li>");
      }
      $list.append($li);
      return jQuery(".message-list ul").scrollTop(jQuery(".message-list ul")[0].scrollHeight);
    };

    Chat.prototype._init_event = function() {
      jQuery("input[name='message']").on('keydown', (function(_this) {
        return function(evt) {
          if (evt.keyCode === 13) {
            return _this.send_message();
          }
        };
      })(this));
      return jQuery("button.send").on('click', (function(_this) {
        return function() {
          return _this.send_message();
        };
      })(this));
    };

    Chat.prototype.login = function() {
      jQuery('.login-panel').addClass('hidden');
      return jQuery('.chat-panel').removeClass('hidden');
    };

    return Chat;

  })();

  jQuery(function() {
    return jQuery(".login-panel button.login").on('click', function(evt) {
      var $chanel_ele, $username_ele, chanel, chat, username;
      evt.preventDefault();
      $username_ele = jQuery(".login-panel input[name='username']");
      username = jQuery.string_strip($username_ele.val());
      $chanel_ele = jQuery(".login-panel input[name='chanel']");
      chanel = jQuery.string_strip($chanel_ele.val());
      $username_ele.closest(".form-group").removeClass('has-error');
      $username_ele.closest(".form-group").find("label").text("");
      $chanel_ele.closest(".form-group").removeClass('has-error');
      $chanel_ele.closest(".form-group").find("label").text("");
      if (jQuery.string_blank(username)) {
        $username_ele.closest(".form-group").addClass('has-error');
        $username_ele.closest(".form-group").find("label").text("请输入昵称");
        return;
      }
      if (jQuery.string_blank(chanel)) {
        $chanel_ele.closest(".form-group").addClass('has-error');
        $chanel_ele.closest(".form-group").find("label").text("请输入频道名");
        return;
      }
      chat = new Chat(username, chanel);
      return chat.login();
    });
  });

}).call(this);
