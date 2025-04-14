extends Node

signal notify_connected(playername)

func player_connected(playername):
	emit_signal("notify_connected", playername)
