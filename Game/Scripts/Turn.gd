extends Sprite2D

var speed = 400
var angular_speed = PI

func _process(delta):
	var velocity = Vector2.UP.rotated(rotation) * speed
	rotation += angular_speed * delta
	position += velocity * delta
