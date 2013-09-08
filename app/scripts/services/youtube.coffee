tooglesApp.service "youtube", ["$http", ($http) ->
  urlBase = "https://gdata.youtube.com/feeds/api/"
  offset = 1
  count = 24
  callback = "searchCallback"
  duration = false
  time = false
  orderBy = false
  searchType = "videos"
  @setPage = (page) ->
    offset = page * count + 1

  @setSort = (sort) ->
    orderBy = sort

  @setTime = (when_) ->
    time = when_

  @setDuration = (length) ->
    duration = length

  @setType = (type) ->
    searchType = type

  @setCallback = (fn) ->
    callback = fn

  @getItem = (type, id) ->
    url = "https://gdata.youtube.com/feeds/api/" + type + "/" + id + "?safeSearch=none&v=2&alt=json&callback=" + callback
    $http.jsonp url

  @getVideos = (type, query) ->
    query = encodeURIComponent(query)
    if type is "related"
      
      # All videos by a user
      url = urlBase + "videos/" + query + "/related?&v=2&alt=json&callback=" + callback
    else if type is "user"
      
      # All videos by a user
      url = urlBase + "users/" + query + "/uploads?start-index=" + offset + "&max-results=" + count + "&v=2&alt=json&callback=" + callback
    else if type is "user_favorites"
      
      # All videos by a user
      url = urlBase + "users/" + query + "/favorites?start-index=" + offset + "&max-results=" + count + "&v=2&alt=json&callback=" + callback
    else if type is "user_subscriptions"
      
      # All videos by a user
      url = urlBase + "users/" + query + "/newsubscriptionvideos?start-index=" + offset + "&max-results=" + count + "&v=2&alt=json&callback=" + callback
    else if type is "user_playlists"
      
      # All videos by a user
      url = urlBase + "users/" + query + "/playlists?start-index=" + offset + "&max-results=" + count + "&v=2&alt=json&callback=" + callback
    else if type is "category"
      
      # All videos within a category
      url = urlBase + "standardfeeds/most_viewed_" + query + "?time=today&start-index=" + offset + "&max-results=" + count + "&safeSearch=none&v=2&alt=json&callback=" + callback
    else if type is "search"
      
      # A search query for videos
      path = "videos"
      path = "playlists/snippets"  if searchType is "playlists"
      url = urlBase + path + "?q=" + query + "&start-index=" + offset + "&max-results=" + count + "&safeSearch=none&v=2&alt=json&callback=" + callback
      url += "&time=" + time  if time
      url += "&duration=" + duration  if duration
      url += "&orderby=" + orderBy  if orderBy and searchType isnt "playlists"
    else
      
      # Most popular recent videos
      url = urlBase + "standardfeeds/most_viewed?time=today&start-index=" + offset + "&max-results=" + count + "&safeSearch=none&v=2&alt=json&callback=" + callback
    $http.jsonp url

  
  # Take a URL with an ID in it and grab the ID out of it. Helper function for YouTube URLs.
  @urlToID = (url) ->
    if url
      parts = url.split("/")
      parts = url.split(":")  if parts.length is 1 # Some URLs are separated with : instead of /
      parts.pop()

  @formatDuration = (seconds) ->
    sec_numb = parseInt(seconds)
    hours = Math.floor(sec_numb / 3600)
    minutes = Math.floor((sec_numb - (hours * 3600)) / 60)
    seconds = sec_numb - (hours * 3600) - (minutes * 60)
    minutes = "0" + minutes  if minutes < 10 and hours isnt 0
    seconds = "0" + seconds  if seconds < 10
    time = minutes + ":" + seconds
    time = hours + ":" + time  if hours isnt 0
    time
]
