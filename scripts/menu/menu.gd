extends Control

var tutorialCompleted = false


func _ready():
	if Global.config.tutorialCompleted:
		$newBtn.disabled = false
		$newBtn/RichTextLabel.bbcode_text = "[center]Start A New Game[/center]"
	else:
		$newBtn.disabled = true
		$newBtn/RichTextLabel.bbcode_text = "[center][color=#90a1a8]Start A New Game[/color][/center]"

func _on_tutorialBtn_button_up():
	get_parent().changeGameState(Global.GameState.Tutorial)


func _on_newBtn_button_up():
	get_parent().changeGameState(Global.GameState.Game)


func _on_quitBtn_button_up():
	get_tree().quit()