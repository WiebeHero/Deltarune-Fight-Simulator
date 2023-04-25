extends Label

@export var animatorPath:NodePath
@onready var animator:AnimationPlayer = get_node_or_null(animatorPath) :
	get:
		return animator
@onready var timer:Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_text_finished(anim_name):
	timer.start()


func _on_timer_timeout():
	queue_free()
