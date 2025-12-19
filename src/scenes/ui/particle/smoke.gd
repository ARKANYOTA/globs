extends CanvasGroup
class_name SmokeParticle

@onready var cpu_particles_2d: CPUParticles2D = %CpuParticles2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = %AudioStreamPlayer2D
func _ready() -> void:
    var tween = create_tween()
    # tween.tween_property(self, "self_modulate:a", 0.0, 1.0)
    cpu_particles_2d.emitting = true
    cpu_particles_2d.one_shot = true
    audio_stream_player_2d.play()
    await cpu_particles_2d.finished
    queue_free()