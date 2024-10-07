extends Node2D

@export_group("Enemy Stats")
@export var lvl := 3
@export var amount := 10
@onready var word_index_array = EnemyStats.get_word(amount)

var word_index_array_index = 0 #index for what word you're on
var word_letter_index = 0 #index for what letter you're on

var is_targeted = true
var current_word: String

func _ready():
	current_word = EnemyStats.word_dictionary.get(lvl)[word_index_array[word_index_array_index]]
	color_word()
	
#TODO - deal with upper-case letters
func _unhandled_key_input(event):
	if is_targeted and event is InputEventKey and event.is_pressed():
		var typed_key = event as InputEventKey
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
		color_word()
				

func color_word():
	$RichTextLabel.clear()
	if word_letter_index == 0:
			$RichTextLabel.push_color(Color.GREEN)
			$RichTextLabel.add_text(current_word[0])
			$RichTextLabel.pop_context()
			$RichTextLabel.add_text(current_word.substr(1))
			$RichTextLabel.add_text(' (' + str(amount) + ')')
	else:
		$RichTextLabel.add_text(current_word.substr(0, word_letter_index))
		$RichTextLabel.push_color(Color.GREEN)
		$RichTextLabel.add_text(current_word[word_letter_index]) 
		$RichTextLabel.pop_context()
		$RichTextLabel.add_text(current_word.substr(word_letter_index + 1))
		$RichTextLabel.add_text(' (' + str(amount) + ')')
