extends Node2D

var control:bool = true
@onready var buttons:Array[TextureButton] = [$TotalMenu/Buttons/FightButton as TextureButton, $TotalMenu/Buttons/ActButton as TextureButton, $TotalMenu/Buttons/ItemButton as TextureButton, $TotalMenu/Buttons/DefendButton as TextureButton, $TotalMenu/Buttons/MagicButton as TextureButton, $TotalMenu/Buttons/SpareButton as TextureButton]
@onready var activeButton:TextureButton = buttons[0]
var normalTexture:Texture

var maxHealthAnimFrames:int = 20
var healthAnimFrames:int = 1
var prevPercentage:float = 0.0

@export var buttonParentPath:NodePath
@onready var _buttonParent:TextureButton = get_node_or_null(buttonParentPath)

@export var krisPath:NodePath
@onready var kris:RigidBody2D = get_node_or_null(krisPath)

@export var animatorPath:NodePath
@onready var animator:AnimationPlayer = get_node_or_null(animatorPath)

@export var timerPath:NodePath
@onready var timer:Timer = get_node_or_null(timerPath)

var _hpBarOriginalSizes:Array[float] = []

@export var _hpBarPath:Array[NodePath]
var _hpBars:Array[ColorRect]

@export var _healthTextPath:Array[NodePath]
var _healthText:Array[Label]

@export var _maxHealthTextPath:Array[NodePath]
var _maxHealthText:Array[Label]

const damageText = preload('res://Scenes/UserInterface/DamageText.tscn')
var damageTextInstance:Label

signal requestFightAction(action:AttackType)

# Called when the node enters the scene tree for the first time.
func _ready():
	animator.play("Activity")
	for x in _healthTextPath:
		_healthText.append(get_node_or_null(x))
	for x in _maxHealthTextPath:
		_maxHealthText.append(get_node_or_null(x))
	for x in _hpBarPath.size():
		_hpBars.append(get_node_or_null(_hpBarPath[x]))
		_hpBarOriginalSizes.append(_hpBars[x].size.x)
	normalTexture = activeButton.texture_normal
	activeButton.texture_normal = activeButton.texture_hover

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var hovering:bool = false
	for button in buttons:
		if !button.is_hovered():
			hovering = true
			continue
		if activeButton == button:
			continue
		activeButton.texture_normal = normalTexture
		activeButton = button
		normalTexture = activeButton.texture_normal
	if !hovering:
		activeButton = null

func _input(event):
	if !(event is InputEventKey):
		return
	if activeButton == null:
		activeButton = buttons[0]
		normalTexture = activeButton.texture_normal

func _on_kriss_player_ready(health, maxHealth):
	for x in _healthText:
		x.text = str(health)
	for x in _maxHealthText:
		x.text = str(maxHealth)

func _on_fight_button_button_down():
	if !kris._turn:
		return
	kris._turn = false
	_buttonParent.set_process(false)
	requestFightAction.emit(AttackType.Regular)

func _on_kriss_damaged(damage):
	var health:int = kris.get('_health')
	var maxHealth:int = kris.get('_maxHealth')
	var healthString:String = str(health)
	var maxHealthString:String = str(maxHealth)
	prevPercentage = (float(health) + damage) / float(maxHealth)
	for x in _healthText:
		x.text = str(health)
	for x in _maxHealthText:
		x.text = str(maxHealth)
	damageTextInstance = damageText.instantiate()
	kris.add_child(damageTextInstance)
	damageTextInstance.text = str(damage)
	damageTextInstance.animator.play("TextAppearV2")
	timer.start()

func _on_health_timeout():
	if healthAnimFrames == maxHealthAnimFrames:
		healthAnimFrames = 0
		timer.stop()
		return
	var health:float = float(kris.get('_health'))
	var maxHealth:float = float(kris.get('_maxHealth'))
	var healthPercentage:float = health / maxHealth
	var newPercentage:float = (prevPercentage - healthPercentage) / maxHealthAnimFrames
	for x in _hpBars.size():
		var originalSize:int = _hpBarOriginalSizes[x]
		var hpBar:ColorRect = _hpBars[x]
		_hpBars[x].size.x = prevPercentage * originalSize - (newPercentage * healthAnimFrames * originalSize)
	healthAnimFrames += 1

func _on_button_hovered():
	pass # Replace with function body.
