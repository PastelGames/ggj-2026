class_name ResponseData
extends Resource

enum ResponseType {CHANGE_SCENE, NEW_DIALOGUE}

@export var text: String
@export var type: ResponseType
@export var payload: Variant
