## Shows the exhaust particles while thrust is held.
extends AnimatedSprite2D

@onready var thrust_particles: CPUParticles2D = $"../CPUParticles2D"


func _process(_delta: float) -> void:
	thrust_particles.emitting = Input.is_action_pressed("thrust")
