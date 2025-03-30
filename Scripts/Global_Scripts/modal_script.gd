extends Node

@onready var closeButton = $"Background Panel/Panel/Close Button"
@export var modal_label = ""

func _ready():
	var textLabel = $"Background Panel/Panel/Modal Label"
	textLabel.text = modal_label
	
	#add the close button for start
	closeButton.pressed.connect(close_modal)

func close_modal():
	var modal = $"."
	PlayerGlobalScript.modal_open = false
	modal.visible = false
