extends Node2D


func setTurn(id):
	if id <= 1:
		$Sprite.frame = 1
	else:
		$Sprite.frame = 0

func setStrength(power):
	$Label.set_text(str(power))
	
