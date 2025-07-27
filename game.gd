extends Node

var playerScore = 0
var cpuScore = 0
var winScore = 5
var gameState = GameState.play
var soundPool := []
var ignoreInput = false
var endGameSound = AudioStreamPlayer.new()

const num_hit_sounds = 3

@onready
var paddle = $"../Paddle"

@onready
var cpu = $"../CpuPaddle"

@onready
var ball = %Ball

@onready
var leftBarrier = %Left

@onready
var rightBarrier = %Right

@onready
var scoreLabel = %Score

func _ready() -> void:
	leftBarrier.connect("left_barrier_entered", cpuScored)
	rightBarrier.connect("right_barrier_entered", playerScored)
	
	if GameSettings.enableSound:
		_setupAudio()
		ball.connect("ball_collided_with_paddle", playBallHitSound)
	
	_updateScoreLabel()
	winScore = GameSettings.winScore
	
	match GameSettings.difficulty:
		GameSettings.Difficulty.easy:
			ball.initialSpeed = 200
			ball.increaseSpeedOnCollision = false
			cpu.speed = 100
		GameSettings.Difficulty.medium:
			ball.initialSpeed = 300
			ball.increaseSpeedOnCollision = true
			cpu.speed = 300
		GameSettings.Difficulty.hard:
			ball.initialSpeed = 400
			ball.increaseSpeedOnCollision = true
			cpu.speed = 500
	resetGame()

func _restartGame() -> void:
	%GameOver.visible = false
	playerScore = 0
	cpuScore = 0
	_updateScoreLabel()
	gameState = GameState.play
	resetGame()

func _input(event: InputEvent) -> void:	
	if event.is_action_pressed("action_exit"):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	elif gameState == GameState.over and not ignoreInput:
		_restartGame()
		
func _setupAudio() -> void:
	for i in num_hit_sounds:
		var player = AudioStreamPlayer.new()
		player.stream = load("res://assets/pop%d.mp3" % i)
		add_child(player)
		soundPool.append(player)
	add_child(endGameSound)

func resetGame() -> void:
	paddle.reset()
	ball.reset()
	await get_tree().create_timer(1.0).timeout
	ball.launch()
	
func playerScored() -> void:
	playerScore += 1
	_updateScoreLabel()
	if playerScore == winScore:
		_handleGameOver()
	else:
		resetGame()

func cpuScored() -> void:
	cpuScore += 1
	_updateScoreLabel()
	
	if cpuScore == winScore:
		_handleGameOver()
	else:
		resetGame()

func playBallHitSound() -> void:
	soundPool[randi_range(0, num_hit_sounds - 1)].play()

func _handleGameOver() -> void:
	ignoreInput = true
	if GameSettings.enableSound:
		_playGameOverSound()
	_showGameOver(true)
	gameState = GameState.over
	paddle.reset()
	ball.reset()
	cpu.reset()
	await get_tree().create_timer(2.0).timeout
	ignoreInput = false
	

func _showGameOver(visible: bool) -> void:
	if playerScore > cpuScore:
		%GameOver.text = "You Win!"
	else:
		%GameOver.text = "You Lose :("
	%GameOver.visible = true

func _playGameOverSound() -> void:
	if playerScore > cpuScore:
		endGameSound.stream = preload("res://assets/win.mp3")
	else:
		endGameSound.stream = preload("res://assets/loss.mp3")
	endGameSound.play()

func _updateScoreLabel() -> void:
	scoreLabel.text = "Player: %s\nCPU: %s" % [playerScore, cpuScore]
	
enum GameState {
	play,
	over
}
