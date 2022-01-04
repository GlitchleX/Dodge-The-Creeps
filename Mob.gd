extends RigidBody2D
# Called when the node enters the scene tree for the first time.
# 노드가 씬에 처음 등장헀을때 한번 실행
func _ready():
	$AnimatedSprite2D.playing = true # 애니메이션이 움직이게 설정
	
	# mob_types 에 애니메이트스프라이트의 프레임의 이름들을 가져옴. (fly, swim, walk)
	var mob_types = $AnimatedSprite2D.frames.get_animation_names()
	
	# 애니메이션 프레임을 3개 중 랜덤으로 하나를 고름
	# randi() % n은 0과 n-1 사이의 임의의 정수를 선택
	$AnimatedSprite2D.animation = mob_types[randi() % mob_types.size()]

# 화면을 나갔을 때 실행
func _on_Visibility_screen_exited():
	queue_free() # 자신을 삭제
