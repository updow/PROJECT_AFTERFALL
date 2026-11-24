extends Node3D

const PLAYER_SCENE = preload("res://scenes/player/Player.tscn")

func _ready():
    create_environment()
    create_ground()
    create_player()

func create_environment():
    var environment_node = WorldEnvironment.new()
    var env = Environment.new()

    env.background_mode = Environment.BG_SKY
    env.sky = Sky.new()
    env.sky.sky_material = ProceduralSkyMaterial.new()

    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color(0.65, 0.68, 0.72)
    env.ambient_light_energy = 0.7

    environment_node.environment = env
    add_child(environment_node)

    var sunlight = DirectionalLight3D.new()
    sunlight.rotation_degrees = Vector3(-50, -30, 0)
    sunlight.shadow_enabled = true
    sunlight.light_energy = 1.0
    add_child(sunlight)

func create_ground():
    var ground_body = StaticBody3D.new()
    ground_body.name = "Ground"
    ground_body.position.y = -0.5
    add_child(ground_body)

    var ground_mesh = MeshInstance3D.new()
    var mesh = BoxMesh.new()
    mesh.size = Vector3(100, 1, 100)
    ground_mesh.mesh = mesh

    var material = StandardMaterial3D.new()
    material.albedo_color = Color(0.22, 0.32, 0.19)
    ground_mesh.material_override = material

    ground_body.add_child(ground_mesh)

    var collision = CollisionShape3D.new()
    var shape = BoxShape3D.new()
    shape.size = Vector3(100, 1, 100)
    collision.shape = shape
    ground_body.add_child(collision)

func create_player():
    var player = PLAYER_SCENE.instantiate()
    player.name = "Player"
    player.position = Vector3(0, 0.1, 5)
    add_child(player)
