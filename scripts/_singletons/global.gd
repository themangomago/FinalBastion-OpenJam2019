extends Node

var gm = null

enum TileAfterLife {Nothing, Die, Explode}


var config = {
	"fullscreen": true,
	"volume": 10
}

func _ready():
	loadConfig()
	windowScale(2)

func setGameMaster(node):
	gm = node


func getGameMaster():
	return gm


func loadConfig():
	pass


func windowScale(scale = 2):
	var initSize = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))
	var screenSize = OS.get_screen_size(OS.get_current_screen())
	var windowSize = initSize * scale
	OS.set_window_position((screenSize - windowSize) / 2)
	OS.set_window_size(windowSize)

func fullscreen():
	if OS.window_fullscreen:
		OS.window_fullscreen = false
		windowScale(1)
	else:
		windowScale(3)
		OS.window_fullscreen = true
