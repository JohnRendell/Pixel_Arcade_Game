extends Node

@onready var modal = $"."
@onready var panel = $"Background Panel/Panel"
@onready var closeButton = $"Background Panel/Panel/Close Button"
@onready var animate_modal = $"Background Panel/Panel/AnimationPlayer"
@export var modal_button = Button
@export var modal_label = "Modal Label"

func _ready():
	var textLabel = $"Background Panel/Panel/Modal Label"
	textLabel.text = modal_label
	
	#add the button's functionality on start
	modal_button.pressed.connect(open_modal)
	closeButton.pressed.connect(close_modal)
	
	panel.position.y = -300
	panel.add_theme_color_override("bg_color", "#ffffff45")

func open_modal():
	modal.visible = true
	animate_modal.play("pop_modal")
	PlayerGlobalScript.modal_open = true
	
	#TODO: do something for this
	for child in panel.get_children():
		print(child.name)

func close_modal():
	animate_modal.play_backwards("pop_modal")
	PlayerGlobalScript.modal_open = false

func _on_animation_player_animation_finished(anim_name: StringName):
	if anim_name == "pop_modal" and PlayerGlobalScript.modal_open == false:
		modal.visible = false
		
		panel.position.y = -300
		panel.add_theme_color_override("bg_color", "#ffffff45")
