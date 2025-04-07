extends Node

@export var navigate_to_scene = "path of the scene"
@onready var progressBar = $ProgressBar
var progress_value = 0

@export var begin_load = false
var loading_started = false
var loading_done = false

func _process(_delta: float):
	if begin_load and not loading_started:
		ResourceLoader.load_threaded_request(navigate_to_scene)
		loading_started = true
		
	if loading_started and not loading_done:
		var progress = []
		var status = ResourceLoader.load_threaded_get_status(navigate_to_scene, progress)

		if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
			progress_value = progress[0] * 100
		
		elif status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			loading_done = true
			progressBar.value = 100
			get_tree().change_scene_to_file(navigate_to_scene)
		progressBar.value = progress_value
