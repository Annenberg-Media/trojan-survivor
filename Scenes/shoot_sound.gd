extends AudioStreamPlayer2D

func play_sound(count = 1):
	for i in range(count):
		pitch_scale = randf_range(0.9, 1.1)
		play()
		await get_tree().create_timer(0.05).timeout
