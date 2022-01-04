extends Area2D
signal hit

export var speed = 400 # Pixel per Second
var screen_size # Size of game window

# Called when the node enters the scene tree for the first time.
# 노드가 씬에 처음 등장헀을때 한번 실행
func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0 # 0 초과 = True 0 미만 = False
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

func _on_Player_body_entered(body): # 어떤 물체에 충돌했을 때
	hide() # 자신을 숨김
	emit_signal("hit") # 위에서 만든 hit 시그널(신호)을 보냄
	$CollisionShape2D.set_deferred("disabled", true) # deferred = 연기하다(미루다)
	# 물리적 충돌을 비활성화를 할 수가 없으므로 연기를 함
	# 엔진의 충돌 처리 도중에 영역의 콜리전 모양을 비활성화하면 오류가 발생할 수 있습니다.
	# set_deferred()를 사용하면 Godot가 모양을 비활성화 하기에 안전해질 때까지 기다려줍니다.
	
func start(pos): #게임을 시작하는 함수
	position = pos # position 은 기본 변수로 추정, pos는 다른데에서 
	show() # 보여줌
	$CollisionShape2D.disabled = false # 충돌영역 비활성화를 비활성화

