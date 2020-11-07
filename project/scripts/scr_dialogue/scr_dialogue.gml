function dialogue_create(_dialogue) {

	if(instance_exists(obj_textbox)){ return; }

	//Create the Textbox
	var _textbox = instance_create_layer(1, 1, "Text", obj_textbox);
	_textbox.init(_dialogue, object_index, fnt_dialogue);
	return _textbox;
}
