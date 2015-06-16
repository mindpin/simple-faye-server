info =
  chanel: "/foo"
  username: "fushang318"

search = window.location.search
jQuery.each search.replace("?","").split("&"), (i,str)->
  arr = str.split("=")
  key = arr[0]
  value = arr[1]
  if key == "username"
    info.username = value
  if key == "chanel"
    info.chanel = "/#{value}"

process =
  client: new Faye.Client('http://faye.4ye.me:9527/faye')
  send_message: ->
    message = jQuery("input[name='message']").val()
    message = message.replace(/(^\s*)|(\s*$)/g,'');
    return if message == undefined || message.length == 0

    pub = process.client.publish info.chanel,
      text: message
      username: info.username

    jQuery("input[name='message']").val("")

    pub.then null, ->
      alert('There was a problem: ' + error.message)

  add_message_to_list: (data)->
    username = data.username
    text     = data.text
    $list = jQuery(".message-list ul")
    if username == info.username
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

process.client.subscribe info.chanel, (data)->
  process.add_message_to_list(data)


jQuery ->
  jQuery("input[name='message']").on 'keydown', (evt)->
    if evt.keyCode == 13
      process.send_message()

  jQuery("button.send").on 'click', ->
    process.send_message()
