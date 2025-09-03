extends NPCsState

func enter() -> void:
	print("[Enemy][State]: Die")
	super()
	
	parent.status_history.append(self)
	
	parent.shoot_ray_cast.enabled = false
	parent.player_detector.enabled = false
	parent.AttackingState.attacking_timer.stop()
	
	Global.saving_slats.slat1.enemies_killed.append(parent.get_rid())
	Global.save_game()

#func process_frame(_delta: float) -> NPCsState:
	#return null
