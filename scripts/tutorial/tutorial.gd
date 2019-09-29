extends Control

const nameTag = "[color=#51c43f]Jolie[/color]: "

var tutorialTexts = [
"Welcome Commander to the [color=#852d66]Final Bastion[/color]! A large meteoroid storm is incoming.",
"Defend the Earth from incoming meteoroids while we are evacuating it."
]

var tutorialStep = 0

onready var textNode = $textBg/tutorialText

func nextStep():
	tutorialStep += 1
	$textBg/nextBtn.hide()

	match tutorialStep:
		1:
			animateText(tutorialTexts[1])

func init():
	tutorialStep = 0
	$textBg/nextBtn.hide()
	animateText(tutorialTexts[0])

func animateText(string):
	textNode.set_bbcode(nameTag + string)
	textNode.set_visible_characters(6)
	$textDelay.start()


func _on_textDelay_timeout():
	if textNode.get_visible_characters() < textNode.get_total_character_count():
		textNode.set_visible_characters(textNode.get_visible_characters() + 1)
	else:
		$textBg/nextBtn.show()
		$textDelay.stop()


func _on_nextBtn_button_up():
	nextStep()
