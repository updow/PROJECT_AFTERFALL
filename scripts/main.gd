extends Node3D

func _ready():
    var environment = WorldEnvironment.new()
    var env = Environment.new()
    env.background_mode = Environment.BG_SKY
    env.sky = Sky.new()
    env.sky.sky_material = ProceduralSkyMaterial.new()
    environment.environment = env
    add_child(environment)

    var light = DirectionalLight3D.new()
    light.rotation_degrees = Vector3(-50, -30, 0)
    light.shadow_enabled = true
    add_child(light)

    var ground = MeshInstance3D.new()
    var mesh = BoxMesh.new()
    mesh.size = Vector3(100, 1, 100)
    ground.mesh = mesh
    ground.position.y = -0.5

    var material = StandardMaterial3D.new()
    material.albedo_color = Color(0.22, 0.32, 0.19)
    ground.material_override = material
    add_child(ground)

    print("PROJECT AFTERFALL iniciado.")
