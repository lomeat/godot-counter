extends CanvasLayer

var count: int = 0
var time: float = 0.0
var score: String = "%2.1f" % time + "s"
var player_name: String = ""
var count_limits = [10, -5]

var highs : Dictionary

signal game_over

func _ready():
	$DecButton.disabled = true
	$IncButton.disabled = true
	
func new_game():
	count = 0
	time = 0
	$Timer.start()
	$StartButton.disabled = true
	$DecButton.disabled = false
	$IncButton.disabled = false
	if (!game_over.is_connected(_on_game_over)):
		game_over.connect(_on_game_over)
	$PlayerNameEdit.hide()
	
func _process(delta: float) -> void:
	$CountLabel.text = str(count)
	if count not in range(-4, 10):
		game_over.emit()


func _on_dec_button_pressed() -> void:
	count -= 1
	

func _on_inc_button_pressed() -> void:
	count += 1

func _on_timer_timeout() -> void:
	time += $Timer.wait_time
	score = "%2.1f" % time + "s"
	$TimerLabel.text = score
	$Timer.start()
	

func _on_start_button_pressed() -> void:
	new_game()


func _on_game_over() -> void:
	game_over.disconnect(_on_game_over)
	$Timer.stop()
	$DecButton.disabled = true
	$IncButton.disabled = true
	$StartButton.disabled = false
	highs[player_name] = score
	$HighscoresLabel.text += "\n" + str(highs.size()) + ". " + player_name + ": " + highs[player_name]
	$PlayerNameEdit.clear()
	$PlayerNameEdit.show()


func _on_line_edit_text_changed(new_text: String) -> void:
	player_name = new_text
