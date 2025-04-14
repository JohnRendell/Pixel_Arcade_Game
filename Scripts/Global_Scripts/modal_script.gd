extends Node

@onready var modal = $"."
@onready var panel = $"Background Panel/Panel"
@onready var closeButton = $"Background Panel/Panel/Close Button"
@export var modal_button = Button
@export var modal_label = "Modal Label"

func _ready():
	var textLabel = $"Background Panel/Panel/Modal Label"
	textLabel.text = modal_label
	
	#add the button's functionality on start
	modal_button.pressed.connect(open_modal)
	closeButton.pressed.connect(close_modal)
	
	modal.visible = false

func open_modal():
	PlayerGlobalScript.modal_open = true
	modal.visible = true

func close_modal():
	PlayerGlobalScript.modal_open = false
	modal.visible = false
