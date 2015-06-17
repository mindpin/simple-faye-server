jQuery.string_strip = (str)->
  return '' if str == undefined
  str.replace(/(^\s*)|(\s*$)/g,'');
jQuery.string_blank = (str)->
  str = jQuery.string_strip(str)
  str.length == 0

class Chat
  constructor: (@username, @chanel)->
    @chanel = "/#{encodeURI(@chanel)}"
    
    @client = new Faye.Client('http://faye.4ye.me:9527/faye')
    @client.subscribe @chanel, (data)=>
      this.add_message_to_list(data)
    @_init_event()
  send_message: ->
    message = jQuery("input[name='message']").val()
    message = jQuery.string_strip(message)
    return if message.length == 0
    pub = @client.publish @chanel,
      text: message
      username: @username
    jQuery("input[name='message']").val("")
    pub.then null, ->
      alert('信息发送失败')

  add_message_to_list: (data)->
    username = data.username
    text     = data.text
    $list = jQuery(".message-list ul")
    if username == @username
      $li = jQuery("
        <li class='clearfix self'>
          <div class='username'>#{username}</div>
          <div class='message'>#{text}</div>
        </li>
      ")
    else
      $li = jQuery("
        <li class='clearfix other'>
          <div class='username'>#{username}</div>
          <div class='message'>#{text}</div>
        </li>
      ")
    $list.append($li)
    jQuery(".message-list ul").scrollTop( jQuery(".message-list ul")[0].scrollHeight )

  _init_event: ->
    jQuery("input[name='message']").on 'keydown', (evt)=>
      if evt.keyCode == 13
        @send_message()

    jQuery("button.send").on 'click', =>
      @send_message()

  login: ->
    jQuery('.login-panel').addClass('hidden')
    jQuery('.chat-panel').removeClass('hidden')


jQuery ->
  jQuery(".login-panel button.login").on 'click', (evt)->
    evt.preventDefault()
    $username_ele = jQuery(".login-panel input[name='username']")
    username      = jQuery.string_strip $username_ele.val()
    $chanel_ele = jQuery(".login-panel input[name='chanel']")
    chanel      = jQuery.string_strip $chanel_ele.val()

    $username_ele.closest(".form-group").removeClass('has-error')
    $username_ele.closest(".form-group").find("label").text("")
    $chanel_ele.closest(".form-group").removeClass('has-error')
    $chanel_ele.closest(".form-group").find("label").text("")

    if jQuery.string_blank(username)
      $username_ele.closest(".form-group").addClass('has-error')
      $username_ele.closest(".form-group").find("label").text("请输入昵称")
      return
    if jQuery.string_blank(chanel)
      $chanel_ele.closest(".form-group").addClass('has-error')
      $chanel_ele.closest(".form-group").find("label").text("请输入频道名")
      return

    chat = new Chat(username, chanel)
    chat.login()
