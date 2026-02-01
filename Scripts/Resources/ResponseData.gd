class_name ResponseData
extends Resource

enum ResponseType {CHANGE_SCENE, NEW_DIALOGUE}

@export var response_text: String
@export var type: ResponseType
@export var payload: Variant
