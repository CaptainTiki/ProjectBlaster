extends Node2D

const DEBUG_LEVEL = preload("uid://cw3elarsyss1a")
const UI_MANAGER = preload("uid://ducy00re1qvwb")


var level : Level = null
var ui_manager : UIManager = null

func _ready() -> void:
	level = DEBUG_LEVEL.instantiate() as Level
	add_child(level)
	ui_manager = UI_MANAGER.instantiate() as UIManager
	add_child(ui_manager)
	
