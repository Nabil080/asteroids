## Game scene: music and sound toggles, pause.
extends Node2D

@onready var music_button: TextureButton = %MusicButton
@onready var sounds_button: TextureButton = %SoundsButton
@onready var pause_button: TextureButton = %PauseButton
@onready var play_button: TextureButton = %PlayButton
@onready var pause_panel: Panel = $CanvasLayer/PausePanel


func _ready() -> void:
	music_button.toggled.connect(_on_music_button_toggled)
	sounds_button.toggled.connect(_on_sounds_button_toggled)
	pause_button.pressed.connect(_set_pause.bind(true))
	play_button.pressed.connect(_set_pause.bind(false))


func _on_music_button_toggled(muted: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), muted)


func _on_sounds_button_toggled(muted: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SoundEffects"), muted)


func _set_pause(value: bool) -> void:
	get_tree().paused = value
	pause_panel.visible = value
	play_button.visible = value
	pause_button.visible = not value
