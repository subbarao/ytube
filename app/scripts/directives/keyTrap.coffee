tooglesApp.directive 'keyTrap', ->
  (scope, elem) ->
    elem.bind 'keydown', (event) ->
      console.log event.keyCode
      scope.$broadcast('keydown', event.keyCode )
