###
The controller used when viewing an individual video.
###
tooglesApp.controller "ViewCtrl", ["$scope", "$routeParams", "$location", "youtube", ($scope, $routeParams, $location, youtube) ->
  $scope.location = $location # Access $location inside the view.
  $scope.showSidebar = true
  $scope.showRelated = false
  $scope.section = $location.path().split("/")[1]
  $scope.videoTab = (if $scope.section is "view" then "Related" else "Playlist")
  window.viewCallback = (data) ->
    if $scope.section is "view"
      $scope.video = data.entry
      $scope.video.video_id = $routeParams.id
      $scope.video.embedurl = "http://www.youtube.com/embed/" + $scope.video.video_id + "?autoplay=1&theme=light&color=white&iv_load_policy=3&origin=http://toogl.es"
    else
      start = $routeParams.start or 0
      $scope.video = data.feed.entry[start]
      $scope.video.video_id = $scope.video.media$group.yt$videoid.$t
      $scope.video.embedurl = "http://www.youtube.com/embed/videoseries?list=" + $routeParams.id + "&autoplay=1&theme=light&color=white&iv_load_policy=3&origin=http://toogl.es&index=" + start
      $scope.videos = data.feed.entry
    onYouTubeIframeAPIReady $scope.video.video_id, $scope.section
    document.title = $scope.video.title.$t + " | Toogles"

  window.relatedCallback = (data) ->
    $scope.videos = data.feed.entry

  $scope.fetchRelated = ->
    unless $scope.videos
      youtube.setCallback "relatedCallback"
      youtube.getVideos "related", $routeParams.id
    $scope.showRelated = true

  $scope.getLink = (video, index) ->
    if $scope.section is "view"
      "#/view/" + youtube.urlToID(video.media$group.yt$videoid.$t)
    else "#/playlist/" + $routeParams.id + "/" + index  if $scope.section = "playlist"

  $scope.formatDuration = (seconds) ->
    youtube.formatDuration seconds

  youtube.setCallback "viewCallback"
  if $scope.section is "view"
    youtube.getItem "videos", $routeParams.id
  else
    youtube.getItem "playlists", $routeParams.id
  started = false
  onYouTubeIframeAPIReady = (id, section) ->
    player = new YT.Player("player",
      videoId: id
      events:
        onStateChange: (event) ->
          started = true  if event.data is 1
          if started and event.data is -1
            
            # When a new video is started in an existing player, open up its dedicated page.
            if section is "view"
              video_url = event.target.getVideoUrl()
              video_id = video_url.replace("http://www.youtube.com/watch?v=", "").replace("&feature=player_embedded", "")
              window.location = "#/view/" + video_id
            else window.location = "#/playlist/" + event.target.getPlaylistId() + "/" + event.target.getPlaylistIndex()  if section is "playlist"
    )
]
