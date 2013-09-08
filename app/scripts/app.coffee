"use strict"

# Angular setup
window.tooglesApp = angular.module("tooglesApp", ["ngSanitize"]).config(["$routeProvider", ($routeProvider) ->
  $routeProvider.when "/browse",
    templateUrl: "views/list.html"
    controller: "ListCtrl"

  $routeProvider.when "/browse/:category",
    templateUrl: "views/list.html"
    controller: "ListCtrl"

  $routeProvider.when "/search/:query",
    templateUrl: "views/list.html"
    controller: "ListCtrl"

  $routeProvider.when "/view/:id",
    templateUrl: "views/view.html"
    controller: "ViewCtrl"

  $routeProvider.when "/view/:username/:id",
    templateUrl: "views/view.html"
    controller: "ViewCtrl"
    resolve:
    	videos: [ 'youtube', (youtube) ->
    		youtube.setCallback "searchCallback"
    		youtube.getVideos "search", $scope.query
    	]

  $routeProvider.when "/playlist/:id",
    templateUrl: "views/view.html"
    controller: "ViewCtrl"

  $routeProvider.when "/playlist/:id/:start",
    templateUrl: "views/view.html"
    controller: "ViewCtrl"

  $routeProvider.when "/user/:username",
    templateUrl: "views/list.html"
    controller: "ListCtrl"


  $routeProvider.when "/user/:username/:feed",
    templateUrl: "views/list.html"
    controller: "ListCtrl"

  $routeProvider.otherwise redirectTo: "/browse"
])
