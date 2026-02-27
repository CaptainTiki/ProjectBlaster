extends Node2D


@onready var label: Label = $CanvasLayer/DebugOutput/Label
@onready var enemy_root: Node2D = $EnemyRoot


@export var sequence : Array[Sequence]
var index = 0

var time : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	label.text = str(snapped(time, 0.01))
	
	if index >= sequence.size():
		set_process(false)
		return
	
	if sequence[index].time <= time:
		var spawn : Node2D = sequence[index].scene.instantiate()
		spawn.global_position = sequence[index].location
		enemy_root.add_child(spawn)
		index += 1
