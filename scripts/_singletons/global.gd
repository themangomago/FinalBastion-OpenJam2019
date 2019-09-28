extends Node

var gm = null

enum GameState {Menu, Tutorial, Game}
enum TileAfterLife {Nothing, Die, Explode}


var config = {
	"tutorialCompleted": false,
	"highscore": 0
}

func _ready():
	loadConfig()
	windowScale(2)

func setGameMaster(node):
	gm = node


func getGameMaster():
	return gm


func saveConfig():
	var cfgFile = File.new()
	cfgFile.open("user://config.cfg", File.WRITE)
	cfgFile.store_line(to_json(config))
	cfgFile.close()

func loadConfig():
	var cfgFile = File.new()
	if not cfgFile.file_exists("user://config.cfg"):
		saveConfig()
		return
	
	cfgFile.open("user://config.cfg", File.READ)
	var data = parse_json(cfgFile.get_line())
	config.tutorialCompleted = data.tutorialCompleted
	config.highscore = data.highscore


func windowScale(scale = 2):
	var initSize = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))
	var screenSize = OS.get_screen_size(OS.get_current_screen())
	var windowSize = initSize * scale
	OS.set_window_position((screenSize - windowSize) / 2)
	OS.set_window_size(windowSize)

func fullscreen():
	if OS.window_fullscreen:
		OS.window_fullscreen = false
		windowScale(2)
	else:
		windowScale(3)
		OS.window_fullscreen = true
