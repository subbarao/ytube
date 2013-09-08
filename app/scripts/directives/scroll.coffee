tooglesApp.directive "whenScrolled", ->
  (scope, elm, attr) ->
    raw = elm[0]
    window.onscroll = ->
      scope.$apply attr.whenScrolled  if window.innerHeight + window.pageYOffset >= document.body.offsetHeight

