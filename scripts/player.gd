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
var flower_field: FlowerField
var head: Node3D
var camera: Camera3D
var ray: RayCast3D
var held_root: Node3D
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
	_build_first_person_hands()
	ray = RayCast3D.new()
	ray.target_position = Vector3(0, 0, -3.0)
	ray.collision_mask = 2
	ray.enabled = true
	camera.add_child(ray)
	held_root = Node3D.new()
	held_root.position = Vector3(0.0, -0.34, -0.76)
	camera.add_child(held_root)
	controls = TouchControls.new()
	controls.name = "TouchControls"
	add_child(controls)
	controls.move_changed.connect(_on_move_changed)
	controls.look_changed.connect(_on_look_changed)
	controls.interact_requested.connect(_on_interact)
	flower_field = get_tree().get_first_node_in_group("flower_field") as FlowerField
	GameState.changed.connect(_update_held_visual)
	_update_held_visual()

func _build_first_person_hands() -> void:
	var hands := Node3D.new()
	hands.name = "FirstPersonHands"
	camera.add_child(hands)
	var sleeve_material := _hand_material(Color("#8da78a"))
	var cuff_material := _hand_material(Color("#e8d8c1"))
	var skin_material := _hand_material(Color("#dba987"))
	var nail_material := _hand_material(Color("#f0c9ad"))
	for side in [-1.0, 1.0]:
		var sleeve := _hand_capsule("Sleeve", 0.074, 0.36, sleeve_material)
		sleeve.position = Vector3(side * 0.49, -0.50, -0.62)
		sleeve.rotation.z = side * 0.55
		hands.add_child(sleeve)
		var cuff := MeshInstance3D.new()
		var cuff_mesh := CylinderMesh.new()
		cuff_mesh.top_radius = 0.082
		cuff_mesh.bottom_radius = 0.082
		cuff_mesh.height = 0.055
		cuff.mesh = cuff_mesh
		cuff.position = Vector3(side * 0.405, -0.36, -0.665)
		cuff.rotation.z = side * 0.55
		cuff.material_override = cuff_material
		hands.add_child(cuff)
		var palm := MeshInstance3D.new()
		var palm_mesh := SphereMesh.new()
		palm_mesh.radial_segments = 12
		palm_mesh.rings = 6
		palm.mesh = palm_mesh
		palm.scale = Vector3(0.12, 0.085, 0.065)
		palm.position = Vector3(side * 0.34, -0.325, -0.68)
		palm.material_override = skin_material
		hands.add_child(palm)
		for finger_index in 4:
			var finger := _hand_capsule("Finger", 0.022, 0.12, skin_material)
			var finger_offset := float(finger_index) - 1.5
			finger.position = Vector3(side * (0.27 + float(finger_index) * 0.052), -0.235 + absf(finger_offset) * 0.012, -0.69)
			finger.rotation.z = side * finger_offset * 0.12
			hands.add_child(finger)
			var nail := MeshInstance3D.new()
			var nail_mesh := SphereMesh.new()
			nail_mesh.radial_segments = 8
			nail_mesh.rings = 4
			nail.mesh = nail_mesh
			nail.scale = Vector3(0.018, 0.027, 0.009)
			nail.position = finger.position + Vector3(0, 0.065, 0.018)
			nail.material_override = nail_material
			hands.add_child(nail)
		var thumb := _hand_capsule("Thumb", 0.024, 0.115, skin_material)
		thumb.position = Vector3(side * 0.245, -0.325, -0.68)
		thumb.rotation.z = -side * 0.75
		hands.add_child(thumb)

func _hand_capsule(node_name: String, radius: float, height: float, material: Material) -> MeshInstance3D:
	var visual := MeshInstance3D.new()
	visual.name = node_name
	var mesh := CapsuleMesh.new()
	mesh.radius = radius
	mesh.height = height
	mesh.radial_segments = 8
	mesh.rings = 3
	visual.mesh = mesh
	visual.material_override = material
	return visual

func _hand_material(color: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.9
	return material

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
	var sensitivity := LOOK_SENSITIVITY * SettingsManager.look_sensitivity
	var vertical_sign := -1.0 if SettingsManager.invert_y else 1.0
	rotate_y(-delta_look.x * sensitivity)
	head.rotate_x(-delta_look.y * sensitivity * vertical_sign)
	head.rotation.x = clampf(head.rotation.x, deg_to_rad(-75), deg_to_rad(75))
	look_delta = Vector2.ZERO
	touch_look = Vector2.ZERO
	ray.force_raycast_update()
	var focused: Object = ray.get_collider() if ray.is_colliding() else null
	var focused_flower_id := ""
	if (focused == null or not focused.is_in_group("interactables")) and is_instance_valid(flower_field):
		focused_flower_id = flower_field.focused_flower(
			camera.global_position,
			-camera.global_transform.basis.z,
			3.0
		)
	if focused != null and focused.is_in_group("interactables"):
		controls.set_prompt(focused.focus_text())
		if interact_pressed:
			focused.interact(self)
	elif not focused_flower_id.is_empty():
		controls.set_prompt(flower_field.focus_text(focused_flower_id))
		if interact_pressed:
			flower_field.interact(focused_flower_id)
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
	for child in held_root.get_children():
		held_root.remove_child(child)
		child.queue_free()
	for index in GameState.inventory.size():
		var flower_id: String = GameState.inventory[index]
		var type := GameState.flower_type_from_id(flower_id)
		var flower := Node3D.new()
		flower.position = Vector3(float(index % 3) * 0.11, float(index / 3) * 0.12, -float(index / 3) * 0.04)
		var stem := MeshInstance3D.new()
		var stem_mesh := CylinderMesh.new()
		stem_mesh.top_radius = 0.012
		stem_mesh.bottom_radius = 0.018
		stem_mesh.height = 0.2
		stem.mesh = stem_mesh
		stem.position.y = -0.08
		var stem_material := StandardMaterial3D.new()
		stem_material.albedo_color = Color("#5c9567")
		stem.material_override = stem_material
		flower.add_child(stem)
		var bloom := MeshInstance3D.new()
		var bloom_mesh := SphereMesh.new()
		bloom_mesh.radius = 0.07
		bloom_mesh.height = 0.13
		bloom.mesh = bloom_mesh
		bloom.position.y = 0.03
		var bloom_material := StandardMaterial3D.new()
		bloom_material.albedo_color = GameState.FLOWER_TYPES[type].color
		bloom.material_override = bloom_material
		flower.add_child(bloom)
		held_root.add_child(flower)
