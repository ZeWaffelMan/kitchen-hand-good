extends Node
class_name SoundChanger


func random_pitch(min: float, max: float) -> float:
	var pitch = randf_range(min, max)
	return pitch
