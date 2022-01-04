extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
# 뭔지 알죠?
func _ready():
	pass # Replace with function body.

func show_message(text):
	# 받은 문자를 라벨에 적용시킴
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	
	# yield = 노드의 시그널이 작동될때 까지 대기
	yield($MessageTimer, "timeout")
	
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	
	# get_tree = 이 노드를 포함하는 트리를 가지고 옴
	# create_timer = One shot 속성을 가진 타이머를 임시로 생성
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	
# Main.gd 에서 사용될 함수
# 점수 변수를 Main.gd에 선언했기 때문에 이런식으로 하는거 같음
func update_score(score):
	$ScoreLabel.text = str(score)
	
func _on_StartButton_pressed(): # 버튼이 눌리면
	$StartButton.hide()
	# 게임을 시작하는 시그널을 보냄
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$Message.hide()
