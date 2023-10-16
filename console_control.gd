extends RichTextLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.custom_minimum_size = Vector2(0.0, float(min(get_content_height(), 150)))
