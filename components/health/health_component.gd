## Holds the health of its parent and tells when it takes damage or runs out.
class_name HealthComponent
extends Node

signal health_changed
signal health_depleted
signal damaged(amount: int)
signal healed(amount: int)

@export var max_health := 1

var current_health: int


func _ready() -> void:
	current_health = max_health


func apply_damage(amount: int) -> void:
	current_health -= amount
	damaged.emit(amount)


func apply_heal(amount: int, overheal := false) -> void:
	current_health += amount
	if not overheal:
		current_health = mini(current_health, max_health)
	healed.emit(amount)


func _on_damaged(_amount: int) -> void:
	health_changed.emit()
	if current_health <= 0:
		health_depleted.emit()


func _on_healed(_amount: int) -> void:
	health_changed.emit()
