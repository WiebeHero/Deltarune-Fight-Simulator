extends RigidBody2D

@export var animatorPath:NodePath
@onready var animator:AnimationPlayer = get_node_or_null(animatorPath)

@onready var attacks = {AttackType.Regular: $RegularAttack}
@onready var timer = $Timer

var _turn:bool = true : 
	get:
		return _turn
	set(value):
		_turn = value

@export_group('Health')
@export var _health:int
@export var _maxHealth:int

@export_group('Damage')
@export var _attack:int

signal player_ready(health:int, maxHealth:int)
signal damaged(damage:int)
signal attacking(damage:int)

# Called when the node enters the scene tree for the first time.
func _ready():
	player_ready.emit(_health, _maxHealth)
	animator.play("KrisDraw")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func attack(multiplier):
	animator.play("KrisAttack")
	var mult:float = 1.0 - multiplier
	var damage:int = 10.0 * mult
	_health -= damage
	attacking.emit(damage)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "KrisDraw":
		animator.play("KrisDrawIdle")
	if anim_name == "KrisDrawIdle":
		animator.play("KrisDrawIdle")
	if anim_name == "KrisAttack":
		timer.start()

func _on_timer_timeout():
	animator.play("KrisDrawIdle")
	_turn = true
	for x in attacks:
		attacks[x].reset()

func _on_timer_button_timeout():
	pass # Replace with function body.

func _on_attack_finished(scaleVariant):
	var multiplier:float = 1
	multiplier -= scaleVariant
	multiplier = abs(multiplier)
	attack(multiplier)

func _on_request_fight_action(action):
	animator.play("KrisAttack")
	animator.seek(0.1, true)
	animator.pause()
	for x in attacks:
		var attack = attacks[x]
		if action == x:
			attack.start()
