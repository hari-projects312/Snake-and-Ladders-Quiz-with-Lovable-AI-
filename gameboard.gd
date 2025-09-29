extends Node2D

# Game variables
var grid_size = 10  # Grid size (10x10)
var square_size = 64  # Size of each square (button)

var squares = []  # Array to store the squares (buttons)
var player_position = 1  # Player's initial position on the grid (starts at square 1)
var player_token = null  # Player's token sprite

# Nodes for quiz UI
var question_label = null
var answer_buttons = []

# Define quiz questions
var questions = []
var current_question = 0

func _ready():
	# Set up the game board (create the grid and buttons)
	setup_board()
	
	# Set up the player token (we'll use a simple circle as the token)
	create_player_token()
	
	# Create the quiz UI (question and answers)
	create_quiz_ui()
	
	# Initialize questions
	questions = [
		{"question": "What is the capital of France?", "answers": ["Paris", "London", "Berlin", "Rome"], "correct": 0},
		{"question": "Who wrote 'Romeo and Juliet'?", "answers": ["Shakespeare", "Dickens", "Hemingway", "Austen"], "correct": 0},
		{"question": "What is the largest planet in our solar system?", "answers": ["Jupiter", "Earth", "Saturn", "Mars"], "correct": 0}
	]
	
	display_question()

# Create the 10x10 game board dynamically (with buttons)
func setup_board():
	# Create a GridContainer to arrange the buttons in a 10x10 grid
	var grid_container = GridContainer.new()
	grid_container.columns = grid_size  # Set columns to 10 (10x10 grid)
	add_child(grid_container)
	
	# Create 100 buttons dynamically (10x10 grid)
	for i in range(grid_size * grid_size):
		var button = Button.new()  # Create a new button
		button.text = str(i + 1)  # Set the button's text to the square number (1, 2, 3,...)
		button.rect_min_size = Vector2(square_size, square_size)  # Set size of each button
		
		# Add the button to the grid container
		grid_container.add_child(button)
		
		# Store the button in the squares array for later reference
		squares.append(button)
		
		# Connect the button's pressed signal to a function that handles the action
		button.connect("pressed", self, "_on_square_pressed", [i])

# Create the player token (simple circle sprite)
func create_player_token():
	var circle = CircleShape2D.new()  # Simple circle shape
	var sprite = Sprite2D.new()
	sprite.texture = preload("res://circle.png")  # Use your own texture or simple placeholder
	player_token = sprite
	add_child(player_token)
	
	# Start the player token at the first square (index 0)
	player_token.position = squares[0].position

# Create quiz UI dynamically (question label and answer buttons)
func create_quiz_ui():
	# Create the question label
	question_label = Label.new()
	question_label.rect_min_size = Vector2(400, 100)
	question_label.align = Label.ALIGN_CENTER
	question_label.valign = Label.VALIGN_CENTER
	question_label.position = Vector2(50, 50)  # Adjust the position as needed
	add_child(question_label)

	# Create the answer buttons
	for i in range(4):
		var button = Button.new()
		button.rect_min_size = Vector2(200, 50)
		button.position = Vector2(50, 150 + i * 60)  # Adjust the spacing
		button.connect("pressed", self, "_on_answer_pressed", [i])
		answer_buttons.append(button)
		add_child(button)

# Display the current quiz question and possible answers
func display_question():
	var question = questions[current_question]
	question_label.text = question["question"]
	
	for i in range(4):
		answer_buttons[i].text = question["answers"][i]

# Handle answer button press
func _on_answer_pressed(answer_index):
	var correct_index = questions[current_question]["correct"]
	
	if answer_index == correct_index:
		print("Correct Answer!")
		move_player(3)  # Move the player forward by 3 squares
	else:
		print("Wrong Answer!")
		move_player(-2)  # Move the player backward by 2 squares
	
	# Update the question and move to the next one
	current_question = (current_question + 1) % questions.size()
	display_question()

# Handle square button press for player movement
func _on_square_pressed(square_index):
	print("Square pressed: ", square_index + 1)
	# Handle player token movement (we will handle it via quiz answers instead)
