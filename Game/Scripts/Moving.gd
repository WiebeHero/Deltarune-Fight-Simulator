extends Sprite2D

var angular_speed = 2.5;
var speed = 100;

func _process(delta):
	var direction = 0
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		direction = -1
	if Input.is_action_pressed("ui_right"):
		direction = 1;
	rotation += angular_speed * direction * delta
	if Input.is_action_pressed("ui_up"):
		velocity = Vector2.UP.rotated(rotation) * speed;
	position += velocity * delta
	


func _on_button_pressed():
	set_process(not is_processing())
