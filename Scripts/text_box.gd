extends MarginContainer

@onready var label = find_child("Label", true, false) as Label
@onready var timer = find_child("LetterDisplayTimer", true, false) as Timer

const MAX_WIDTH = 256  # our text box cannot be wider than this const, in pixels

var text = ""
var letter_index = 0  # used to display text letter by letter 

# time between each type of character
var letter_time = 0.03 
var space_time = 0.06
var punctuation_time = 0.2 

signal finished_displaying()

func _ready() -> void:
	assert(label != null)
	assert(timer != null)

func display_text(text_to_display: String):
	text = text_to_display
	letter_index = 0
	label.text = text_to_display  # size will adjust width based on text to display
	
	await resized
	
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:  # want to wrap text to new line
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized  # resizes x first
		await resized  # then the y, hence two separate awaits 
		custom_minimum_size.y = size.y
	
	# position the text box
	global_position.x -= size.x/2  # centers on x-axis
	global_position.y -= size.y + 24  # just above the "speaker" 
	
	label.text = ""  # set label's text back to blank; the previous setting was
	# just to set the size of the text box 
	
	_display_letter()
	
func _display_letter():
	label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return 
	
	# determine timer time by character type 
	match text[letter_index]:
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:  # any other case 
			timer.start(letter_time)



func _on_letter_display_timer_timeout() -> void:
	_display_letter()
