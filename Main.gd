extends Node

# export 를 사용하면 인스펙터에서 값을 변경할수 가 있음
export(PackedScene) var mob_scene
var score

# Called when the node enters the scene tree for the first time.
# 노드가 씬에 처음 등장헀을때 한번 실행
func _ready():
	# 게임이 실행될때마다 무작위 난수를 생성하는 시드를 무작위로 바꿈
	# 일반적으로 무작위 수를 생성할때 시드가 정해져 있음
	# 같은 시드로 코딩을 한다면 항상 같은 순서로 숫자가 나오게 됨
	# randomize() 는 현재 시간에 따라 시드를 무작위로 바꿈
	randomize()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	# mobs 그룹에게 자신을 삭제하게 함
	get_tree().call_group("mobs", "queue_free")
	$Music.stop()
	$Death.play()
	
# HUD.gd 의 start_game 과 연결 HUD.gd 39번째 줄 참고
func new_game():
	score = 0
	# Player.gd 의 51번째 줄로 감
	$Player.start($StartPosition.position)
	$StartTimer.start()
	# HUD.gd 의 함수를 사용함
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()

func _on_ScoreTimer_timeout(): # 스코어 타이머가 시작되고 1초가 지날 때 마다
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout(): # 시작 타이머가 시작되고 2초가 지난 후 (One Shot 활성화로 한번만 실행됨)
	$ScoreTimer.start()
	$MobTimer.start()

func _on_MobTimer_timeout(): # 몹 타이머가 시작되고 0.5초가 지날 때 마다
	
	# MobPath(Path2D) 는 선으로 위치를 정해주고, MobSpawnLocation(PathFollow2D) 는 Path2D 중 아무 위치를 뽑아냄
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	# randi() 는 무작위 32비트 자연수를 만들어냄 (0 ~ 4294967295)
	# 어짜피 오프셋이라서 일정 수 넘어가면 0으로 돌아가서 더하는 것과 같은 결과가 나옴
	mob_spawn_location.offset = randi()
	
	# 이 함수 내에서 mob은 Mob.gd 의 새 복제본을 말함 (따지고 보면 틀린 설명일수도 있는데 이렇게라도 이해하는게 나을 것 같음)
	# 만약 아래의 줄에서 문제가 발생한다면 Main 노드의 인스펙터에서 Mob Scene 에서 Mob.tscn 을 불러와줘야한다
	var mob = mob_scene.instance()
	# Mob.gd 인스턴스를 이 씬에 추가
	add_child(mob)

	# 몹의 방향을 90도 돌려줌
	# 90도가 아니라 원주율을 사용한 이유는 고도는 라디안을 사용하기 때문
	# (https://ko.wikipedia.org/wiki/%EB%9D%BC%EB%94%94%EC%95%88) 참고
	var direction = mob_spawn_location.rotation + PI / 2
	
	# 몹의 위치 설정
	mob.position = mob_spawn_location.position
	
	# 방향을 약간 다르게 변화해줌
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# 속도를 랜덤으로 정해줌
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	
	# 몹에게 진행방향과 속도를 정해줌
	# linear_velocity 는 한 방향으로 계속 가는 속도로 추측
	mob.linear_velocity = velocity.rotated(direction)
