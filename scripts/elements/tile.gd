extends Node2D

var color = -1
var power = -1

var myAfterLife = Global.TileAfterLife.Nothing

func setup(tcolor, tpower, endPosition = null):
	color = tcolor

	$Sprite.frame = color
	power = tpower + 1
	$Label.set_text("Level " + str(power))
	if endPosition:
		move(endPosition)

func upgrade():
	power *= 2
	$Label.set_text("Level " + str(power))

func move(to, afterLife = Global.TileAfterLife.Nothing):
	$Tween.interpolate_property(self, "position", position, to, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	myAfterLife = afterLife
	$Tween.start()

func destroy():
	$animation.play("explode")

func _on_Tween_tween_completed(object, key):
	if myAfterLife == Global.TileAfterLife.Die:
		get_parent().remove_child(self)
		queue_free()
	elif myAfterLife == Global.TileAfterLife.Explode:
		destroy()


func _on_animation_animation_finished(anim_name):
	if anim_name == "explode":
		get_parent().remove_child(self)
		queue_free()

