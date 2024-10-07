extends Node2D

@export_group("Enemy Stats")
@export var lvl := 3
@export var amount := 10
@export var move_speed := 1
@onready var word_index_array = EnemyStats.get_word(amount)
@onready var word = $RichTextLabel

var word_index_array_index = 0 #index for what word you're on
var word_letter_index = 0 #index for what letter you're on

var is_targeted = true #will start out as false. When player tabs onto the enemy, it will be set to true
var current_word: String

func _ready():
	current_word = EnemyStats.word_dictionary.get(lvl)[word_index_array[word_index_array_index]]
	color_word()

func _process(delta):
	#passive move speed
	pass
	
#TODO - deal with upper-case letters
func _unhandled_key_input(event):
	if is_targeted and event is InputEventKey and event.is_pressed() and not Input.is_action_just_pressed('capitalize'):
		var typed_key = event as InputEventKey
		#var tk_unicode = OS.get_keycode_string(typed_key.get_keycode_with_modifiers())
		if(typed_key.unicode == current_word.unicode_at(word_letter_index)):
			if word_letter_index != current_word.length() - 1:
				word_letter_index += 1
			else:
				word_letter_index = 0
				if word_index_array_index != word_index_array.size() - 1:
					word_index_array_index += 1
					amount -= 1
					current_word = EnemyStats.word_dictionary.get(lvl)[word_index_array[word_index_array_index]]
				else:
					print('Enemy defeated!')
					queue_free()
		else: 
			printerr('You Fool!')
			word_letter_index = 0
			#move toward player equal to move speed
		color_word()
				

func color_word():
	word.clear()
	if word_letter_index == 0:
			word.push_color(Color.GREEN)
			word.add_text(current_word[0])
			word.pop_context()
			word.add_text(current_word.substr(1))
			word.add_text(' (' + str(amount) + ')')
	else:
		word.add_text(current_word.substr(0, word_letter_index))
		word.push_color(Color.GREEN)
		word.add_text(current_word[word_letter_index]) 
		word.pop_context()
		word.add_text(current_word.substr(word_letter_index + 1))
		word.add_text(' (' + str(amount) + ')')
