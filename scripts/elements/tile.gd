extends Node2D

var color = -1
var power = -1

var myAfterLife = Global.TileAfterLife.Nothing

func setup(tcolor, tpower, endPosition = null):
	color = tcolor

	match color:
		0:
			$ColorRect.modulate = Color(128, 0 , 0 )
		1:
			$ColorRect.modulate = Color(0, 128 , 0 )
		2:
			$ColorRect.modulate = Color(0, 0 , 128 )
			
	power = tpower + 1
	$Label.set_text(str(power))
	if endPosition:
		move(endPosition)

func upgrade():
	power *= 2
	$Label.set_text(str(power))

func move(to, afterLife = Global.TileAfterLife.Nothing):
	$Tween.interpolate_property(self, "position", position, to, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	myAfterLife = afterLife
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	if myAfterLife == Global.TileAfterLife.Die:
		get_parent().remove_child(self)
		queue_free()
	elif myAfterLife == Global.TileAfterLife.Explode:
		print("bang")
		#TODO animation
		get_parent().remove_child(self)
		queue_free()
