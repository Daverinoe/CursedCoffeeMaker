extends Node

var current_task_number : int = -1
var current_task : String
var last_task : bool = false

func display_task(task_text) -> void:
	var task_list : RichTextLabel = %TaskList
	
	hide_tasks()
	
	var tween : Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	
	tween.tween_property(
		task_list,
		"position:x",
		-300,
		0.05
	)
	
	task_list.text = "Task: " + task_text
	
	await tween.finished
	
	show_tasks()
	tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	
	tween.tween_property(
		task_list,
		"position:x",
		50,
		2
	)


func _ready() -> void:
	Event.connect("start_day", start_day)
	Event.connect("end_day", hide_tasks)
	Event.connect("drank_coffee", check_drink_task)
	Event.connect("took_shower", check_shower_task)
	Event.connect("left_for_work", check_leave_task)
	Event.connect("begin_endscene", hide_tasks)


func start_day() -> void:
	current_task_number = -1
	show_tasks()
	get_next_task()


func get_next_task() -> void:
	if !%TaskList.visible:
		return
	current_task_number += 1
	match GlobalRefs.day:
		1:
			current_task = Tasks.day_one[current_task_number]
			if current_task_number == Tasks.day_one.size() - 1:
				last_task = true
		2:
			current_task = Tasks.day_two[current_task_number]
			if current_task_number == Tasks.day_two.size() - 1:
				last_task = true
		3:
			current_task = Tasks.day_three[current_task_number]
			if current_task_number == Tasks.day_three.size() - 1:
				last_task = true
		4:
			current_task = Tasks.day_four[current_task_number]
			if current_task_number == Tasks.day_four.size() - 1:
				last_task = true
	display_task(current_task)


func check_drink_task() -> void:
	if current_task == "Drink a coffee.":
		get_next_task()
		if GlobalRefs.day == 4:
			AudioManager.play_voice("acceptance")
			print(current_task_number)
			return
		AudioManager.play_voice("drink_coffee")
		return


func check_shower_task() -> void:
	if current_task == "Take a shower.":
		AudioManager.play_voice("after_shower")
		get_next_task()
		return


func check_leave_task() -> void:
	if current_task == "Leave for work.":
		if last_task:
			Event.emit_signal("end_day")
			return
		
		get_next_task()
	AudioManager.play_voice("dont_leave")


func show_tasks() -> void:
	%TaskList.visible = true


func hide_tasks() -> void:
	%TaskList.visible = false
