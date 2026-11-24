extends CharacterBody3D

@export var walk_speed: float = 4.0
@export var run_speed: float = 6.5
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.002

var gravity: float = float(ProjectSettings.get_setting("physics/3d/default_gravity"))

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D

func _ready():
    _setup_input()

    if not OS.has_feature("mobile"):
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _setup_input():
    var actions = {
        "move_forward": KEY_W,
        "move_backward": KEY_S,
        "move_left": KEY_A,
        "move_right": KEY_D,
        "run": KEY_SHIFT,
        "jump": KEY_SPACE
    }

    for action in actions:
        if not InputMap.has_action(action):
            InputMap.add_action(action)

        var event = InputEventKey.new()
        event.physical_keycode = actions[action]
        InputMap.action_add_event(action, event)

func _unhandled_input(event):
    if event is InputEventMouseButton:
        if event.pressed and not OS.has_feature("mobile"):
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

    if event.is_action_pressed("ui_cancel"):
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

    if event is InputEventMouseMotion:
        if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
            rotate_y(-event.relative.x * mouse_sensitivity)
            head.rotate_x(-event.relative.y * mouse_sensitivity)
            head.rotation.x = clamp(head.rotation.x, -1.5, 1.5)

func _physics_process(delta):
    if not is_on_floor():
        velocity.y -= gravity * delta

    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = jump_velocity

    var input_dir = Input.get_vector(
        "move_left",
        "move_right",
        "move_forward",
        "move_backward"
    )

    var direction = (transform.basis * Vector3(
        input_dir.x, 0, input_dir.y
    )).normalized()

    var current_speed = run_speed if Input.is_action_pressed("run") else walk_speed

    if direction:
        velocity.x = direction.x * current_speed
        velocity.z = direction.z * current_speed
    else:
        velocity.x = move_toward(velocity.x, 0, current_speed)
        velocity.z = move_toward(velocity.z, 0, current_speed)

    move_and_slide()
