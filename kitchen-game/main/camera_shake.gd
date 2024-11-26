extends Node


@export var camera: Camera2D

@export_category("Camera Shake")
@export var decay: float = 0.8
@export var max_offset: Vector2 = Vector2(150, 100)

var trama: float = 0.0
var trama_power: float = 2.0

var noise = FastNoiseLite.new()
var noise_y: float = 0.0
var noise_speed: float = 3.0


func _ready() -> void:
	CameraShake.camera = camera
	noise.noise_type = FastNoiseLite.TYPE_PERLIN


func add_trama(amount: float) -> void:
	trama = min(trama + amount, 1.0)


func _process(delta) -> void:
	if trama:
		trama = max(trama - decay * delta, 0)
		shake()


func shake() -> void:
	var amount = pow(trama, trama_power)
	noise_y += noise_speed
	camera.offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed * 2, noise_y)
	camera.offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed * 3, noise_y)


func change_speed(time_scale: float, duration: float) -> void:
	Engine.time_scale = lerpf(Engine.time_scale, time_scale, 1.0)
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0


func hit_stop(duration: float) -> void:
	get_tree().paused = true
	await get_tree().create_timer(duration, true, false, true).timeout
	get_tree().paused = false
