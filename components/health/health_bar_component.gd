## Small health bar above its parent. The red part catches up slowly after a hit.
class_name HealthBarComponent
extends Node2D

@export var health_component: HealthComponent

var health := 0

@onready var health_bar: ProgressBar = $HealthBar
@onready var damage_bar: ProgressBar = $HealthBar/DamageBar


func _ready() -> void:
	health = health_component.max_health
	health_bar.max_value = health
	health_bar.value = health
	damage_bar.max_value = health
	damage_bar.value = health
	health_component.damaged.connect(_on_damaged)


func _process(_delta: float) -> void:
	# Stays level while the parent rotates.
	rotation = -get_parent().rotation
	if damage_bar.value > health_bar.value:
		damage_bar.value -= damage_bar.step


func _on_damaged(amount: int) -> void:
	health -= amount
	health_bar.value = health
