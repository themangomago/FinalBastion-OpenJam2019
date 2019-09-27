extends Node2D

var color = -1
var power = -1

func setup(tcolor, tpower):
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