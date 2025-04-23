extends Node

var isLeft = false
var isRight = false
var isUp = false
var isDown = false
var isIdle = false

var playerCoords = "";

#for opening modal and global message modal that restricts player when moving
var modal_open = false
var global_message_open = false

#for setting up player name
var player_name = ""
var player_ID_name = ""
var player_username = ""

#for setting up player status if its logged in or not
var isLoggedIn = false

#for setting up current player scene
var current_scene = ""
