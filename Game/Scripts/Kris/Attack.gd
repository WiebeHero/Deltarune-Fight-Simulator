extends Node2D

var current:int = 0
var currentMovement:int = 0

@export var keysToBePressed:Array[Key]

@onready var buttonTimer:Timer = $ButtonTimer
@onready var decreaseTimer:Timer = $DecreaseTimer
@onready var arrows:Array[Sprite2D] = [$Arrow as Sprite2D, $Arrow2 as Sprite2D, $Arrow3 as Sprite2D]
@onready var originalColors:Array[Color] = [$Arrow.modulate, $Arrow2.modulate, $Arrow3.modulate]
@onready var circles = [$Arrow/Circle, $Arrow2/Circle, $Arrow3/Circle]
@onready var originalScales:Array[Vector2] = [$Arrow/Circle.scale, $Arrow2/Circle.scale, $Arrow3/Circle.scale]

var currentCircles:Array[Node2D] = []
var currentArrows:Array[Sprite2D] = []

var inputsInputted:Array[float]

signal attackFinished(scaleVariant:float)

func _ready():
	for x in circles.size():
		inputsInputted.append(0.00)
	set_process_input(false)

func start():
	set_process_input(true)
	currentCircles.append(circles[currentMovement])
	currentArrows.append(arrows[currentMovement])
	currentMovement += 1
	buttonTimer.start()
	decreaseTimer.start()
	visible = true

func reset():
	for x in circles.size():
		var circle = circles[x]
		circle.scale = originalScales[x]
	for x in arrows.size():
		var arrow = arrows[x]
		arrow.modulate = originalColors[x]
	currentCircles.clear()
	currentArrows.clear()
	visible = false
	currentMovement = 0
	current = 0

func _input(event):
	if current >= circles.size():
		return
	if !(event is InputEventKey):
		return
	if event.keycode != keysToBePressed[current]:
		return
	inputsInputted[current] = circles[current].scale.x
	current += 1
	currentCircles.remove_at(0)
	currentArrows.remove_at(0)
	finish()

func finish():
	if current < circles.size():
		return
	set_process_input(false)
	var total = 0
	for x in inputsInputted:
		total += x
	total /= circles.size()
	attackFinished.emit(total)

func _on_button_timeout():
	if (currentMovement + 1) > circles.size():
		buttonTimer.stop()
		return
	if (current + 1) > circles.size():
		buttonTimer.stop()
		decreaseTimer.stop()
		return
	currentCircles.append(circles[currentMovement])
	currentArrows.append(arrows[currentMovement])
	currentMovement += 1

func _on_decrease_timer_timeout():
	var x = 0
	while x < currentCircles.size():
		var circle = currentCircles[x]
		if circle.scale.x >= 0.8 && circle.scale.y >= 0.8:
			circle.scale.x -= 0.05
			circle.scale.y -= 0.05
		else:
			var arrow = currentArrows[x]
			var c = arrow.modulate
			c.r8 = 50
			c.b8 = 50
			c.g8 = 50
			arrow.modulate = c
			currentCircles.remove_at(x)
			currentArrows.remove_at(x)
			inputsInputted[current] = 0.0
			current += 1
			finish()
			x -= 1
		x += 1
