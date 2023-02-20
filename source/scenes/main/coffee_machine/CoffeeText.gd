extends Label3D

@export_category("Text Display")
@export var text_to_show : String = ""
@export_range(0.0, 10.0) var display_speed : float = 2.0 # Characters per second
@export_range(0, 10) var after_delay : int = 2

var display : bool = false
var text_length : int = 0
var loop_text : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Event.connect("start_display", set_up_text)
	Event.connect("display_finished", set_up_text)


func set_up_text() -> void:
	if display:
		await Event.display_finished
	self.text = text_to_show
	text_length = self.text.length()
	position.x = 0.1 * (text_length + 4)
	display_text()


func display_text() -> void:
	display = true
	var tween : Tween = get_tree().create_tween()
	
	tween.tween_property(
		self,
		"position:x",
		-position.x,
		text_length / display_speed
	)
	
	tween.play()
	
	await tween.finished
	
	# Add small delay time after tween finishes
	await get_tree().create_timer(after_delay).timeout
	
	display = false
	if loop_text:
		Event.emit_signal("display_finished")
