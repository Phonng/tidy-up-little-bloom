extends CharacterBody3D
class_name FPSPlayer

const WALK_SPEED := 3.5
const LOOK_SENSITIVITY := 0.003

var move_input := Vector2.ZERO
var look_delta := Vector2.ZERO
var touch_move := Vector2.ZERO
var touch_look := Vector2.ZERO
var interact_pressed := false
var controls: TouchControls
var head: Node3D
var camera: Camera3D
var ray: RayCast3D
var held_visual: MeshInstance3D
var gravity := float(ProjectSettings.get_setting("physics/3d/default_gravity"))

func _ready() -> void:
	var capsule := CollisionShape3D.new()
	var capsule_shape := CapsuleShape3D.new()
	capsule_shape.radius = 0.32
	capsule_shape.height = 1.7
	capsule.shape = capsule_shape
	capsule.position.y = 0.85
	add_child(capsule)
	head = Node3D.new()
	head.name = "Head"
	head.position.y = 1.52
	add_child(head)
	camera = Camera3D.new()
	camera.current = true
	head.add_child(camera)
	ray = RayCast3D.new()
	ray.target_position = Vector3(0, 0, -3.0)
	ray.collision_mask = 2
	ray.enabled = true
	camera.add_child(ray)
	held_visual = MeshInstance3D.new()
	var held_mesh := SphereMesh.new()
	held_mesh.radius = 0.12
	held_mesh.height = 0.2
	held_visual.mesh = held_mesh
	held_visual.position = Vector3(0.38, -0.3, -0.58)
	var material := StandardMaterial3D.new()
	held_visual.material_override = material
	camera.add_child(held_visual)
	controls = TouchControls.new()
	controls.name = "TouchControls"
	get_tree().root.add_child.call_deferred(controls)
	controls.move_changed.connect(_on_move_changed)
	controls.look_changed.connect(_on_look_changed)
	controls.interact_requested.connect(_on_interact)
	GameState.changed.connect(_update_held_visual)
	_update_held_visual()

func _physics_process(delta: float) -> void:
	var input_vector := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if Input.is_key_pressed(KEY_A):
		input_vector.x = -1.0
	elif Input.is_key_pressed(KEY_D):
		input_vector.x = 1.0
	if Input.is_key_pressed(KEY_W):
		input_vector.y = -1.0
	elif Input.is_key_pressed(KEY_S):
		input_vector.y = 1.0
	if input_vector.length() < 0.01:
		input_vector = touch_move
	var direction := (transform.basis * Vector3(input_vector.x, 0, input_vector.y)).normalized()
	velocity.x = direction.x * WALK_SPEED
	velocity.z = direction.z * WALK_SPEED
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
	move_and_slide()
	var delta_look := look_delta + touch_look
	rotate_y(-delta_look.x * LOOK_SENSITIVITY)
	head.rotate_x(-delta_look.y * LOOK_SENSITIVITY)
	head.rotation.x = clampf(head.rotation.x, deg_to_rad(-75), deg_to_rad(75))
	look_delta = Vector2.ZERO
	touch_look = Vector2.ZERO
	ray.force_raycast_update()
	var focused: Object = ray.get_collider() if ray.is_colliding() else null
	if focused != null and focused.is_in_group("interactables"):
		controls.set_prompt(focused.focus_text())
		if interact_pressed:
			focused.interact(self)
	else:
		controls.set_prompt("")
	interact_pressed = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		look_delta += event.relative
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		interact_pressed = true

func _on_move_changed(value: Vector2) -> void:
	touch_move = value

func _on_look_changed(value: Vector2) -> void:
	touch_look += value

func _on_interact() -> void:
	interact_pressed = true

func _update_held_visual() -> void:
	held_visual.visible = not GameState.inventory.is_empty()
	if not GameState.inventory.is_empty():
		var type := GameState.flower_type_from_id(GameState.inventory[0])
		var material := held_visual.material_override as StandardMaterial3D
		material.albedo_color = GameState.FLOWER_TYPES[type].color
