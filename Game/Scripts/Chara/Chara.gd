extends RigidBody2D

@export var health:int
@export var maxHealth:int

@onready var animator:AnimationPlayer = $AnimationPlayer
const damageText = preload('res://Scenes/UserInterface/DamageText.tscn')

# Called when the node enters the scene tree for the first time.
func _ready():
	animator.play("CharaDraw")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_finished(anim_name):
	if anim_name == "CharaDraw":
		animator.play("CharaDrawIdle")
	if anim_name == "CharaDrawIdle":
		animator.play("CharaDrawIdle")


func _on_kris_attacking(damage):
	health -= damage
	var damageTextInstance = damageText.instantiate()
	add_child(damageTextInstance)
	damageTextInstance.text = str(damage)
	damageTextInstance.animator.play("TextAppearV2")
