LEFT  = 37
UP    = 38
RIGHT = 39
DOWN  = 40
ENTER = 13
###
The controller used when searching/browsing videos.
###
#
tooglesApp.controller "ListCtrl", ["$scope", "$routeParams", "$location", "youtube", ($scope, $routeParams, $location, youtube) ->
  $scope.location = $location
  $scope.searchsort = $location.search()["searchsort"] or false
  $scope.searchduration = $location.search()["searchduration"] or false
  $scope.searchtime = $location.search()["searchtime"] or false
  $scope.section = $location.path().split("/")[1]
  $scope.searchtype = $location.search()["searchtype"] or "videos"
  window.searchCallback = (data) ->
    unless $scope.videos
      $scope.videos = data.feed.entry
    else
      $scope.videos.push.apply $scope.videos, data.feed.entry

  window.userCallback = (data) ->
    $scope.user = data.entry

  $scope.getLink = (video, index) ->
    return "#/playlist/" + video.yt$playlistId.$t  if $scope.resulttype is "playlists"
    "#/view/" + youtube.urlToID(video.media$group.yt$videoid.$t)

  nextVideo = (evt, keyCode) ->
    $scope.index ||=  0
    if keyCode == ENTER
      video = $scope.videos[$scope.index]
      url = video.media$group.yt$videoid.$t
      $location.path "/view/#{url}"

    offset = switch keyCode
      when LEFT   then -1
      when RIGHT  then 1
      when UP     then -4
      when DOWN   then 4
      else 0

    $scope.index = $scope.index + offset
    if $scope.index > $scope.videos.length or $scope.index < 0
      $scope.index = 0

    _.each($scope.videos, (v) -> v.selected = false)
    $scope.videos[$scope.index].selected = true
    $scope.$apply()

  $scope.$on 'keydown', nextVideo

  $scope.page = 0
  $scope.loadMore = ->
    $scope.page = $scope.page + 1
    $scope.search()

  $scope.search = ->
    youtube.setPage $scope.page
    youtube.setCallback "searchCallback"
    if $routeParams.query isnt `undefined` and $routeParams.query isnt "" and $routeParams.query isnt "0"

      # This is a search with a specific query.
      document.title = $routeParams.query + " | Toogles"
      $scope.query = $routeParams.query
      youtube.getVideos "search", $scope.query
    else if $routeParams.category isnt `undefined`

      # This is a category page.
      document.title = $routeParams.category + " | Toogles"
      youtube.getVideos "category", $routeParams.category
    else if $routeParams.username isnt `undefined`

      # This is a user page.
      type = "user"
      if $routeParams.feed isnt `undefined`
        type += "_" + $routeParams.feed
        $scope.resulttype = "playlists"  if $routeParams.feed is "playlists"
      document.title = $routeParams.username + " | Toogles"
      youtube.getVideos type, $routeParams.username
      youtube.setCallback "userCallback"
      youtube.getItem "users", $routeParams.username
    else
      document.title = "Toogles | Awesome goggles for YouTube"
      youtube.getVideos "browse", ""

  $scope.$watch "searchsort + searchtime + searchduration + searchtype", ->
    $scope.videos = false
    youtube.setSort $scope.searchsort
    youtube.setTime $scope.searchtime
    youtube.setDuration $scope.searchduration
    youtube.setType $scope.searchtype
    $scope.resulttype = $scope.searchtype
    $scope.search()

  $scope.urlToID = (url) ->
    youtube.urlToID url

  $scope.formatDuration = (seconds) ->
    youtube.formatDuration seconds
]
