extends Node2D

var data: CardData

var offset: Vector2 = Vector2.ZERO
var initialPos: Vector2 = Vector2.ZERO
var bodyRef: Area2D
var isDroppable: bool = false
var isDragable: bool = false
var nodeOffset: Vector2 = Vector2(0,290)

# Called when the node enters the scene tree for the first time.
func _ready()->void:
  $Name.text = data.name
  $Tag.text = data.tag
  $Innovation.text = str(data.innovation)
  $DevSkills.text = str(data.devSkills)
  $Community.text = str(data.community)
  $Influence.text = str(data.influence)
  $Impact.text = str(data.impact)
  $Wealth.text = str(data.wealth)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float)->void:
  if isDragable:
    if Input.is_action_just_pressed("click"):
      offset = get_global_mouse_position() - global_position
      initialPos = global_position
    if Input.is_action_pressed("click"):
      global_position = get_global_mouse_position() - offset
    elif Input.is_action_just_released("click"):
      var tween := get_tree().create_tween()
      if not isDroppable:
        tween.tween_property(self,"global_position",initialPos,0.2).set_ease(Tween.EASE_IN)
        return
      var newPos := bodyRef.global_position + nodeOffset
      tween.tween_property(self,"position",newPos,0.2).set_ease(Tween.EASE_IN)


func _on_area_2d_mouse_entered()->void:
  isDragable = true
  scale = Vector2(.75,.75)
  z_index = 2

func _on_area_2d_mouse_exited()->void:
  isDragable = false
  scale = Vector2(0.5,0.5)
  z_index = 1

func _on_area_2d_area_entered(body: Area2D)->void:
  if body.name != "Bottom":
    return
  bodyRef = body
  isDroppable = true
  var shade := body.get_node("Shade")
  shade.visible = true

func _on_area_2d_area_exited(body: Area2D)->void:
  if body.name != "Bottom":
    return
  isDroppable = false
  var shade := body.get_node("Shade")
  shade.visible = false
