class_name BoxArea2D extends MovableArea2D



func _on_area_entered(area: Area2D) -> void:
	if area is MovingArea2D:
		area.queue_free()
		self.queue_free()
