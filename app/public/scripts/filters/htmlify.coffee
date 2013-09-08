tooglesApp.filter "htmlify", ->
  (input) ->
    return ""  unless input
    exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/g
    out = input.replace(exp, "<a href='$1'>$1</a>")
    out = out.replace(/\n/g, "<br />")
    out

