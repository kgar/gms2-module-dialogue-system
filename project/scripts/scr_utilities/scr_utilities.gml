function draw_set_color_temp(color, action) {
	var originalColor = draw_get_color();
	draw_set_color(color);
	action();
	draw_set_color(originalColor);
}

function draw_set_font_temp(font, action) {
	var originalFont = draw_get_font();
	draw_set_font(font);
	action();
	draw_set_font(originalFont);
}

function draw_set_valign_temp(valign, action) {
	var originalAlign = draw_get_valign();
	draw_set_valign(valign);
	action();
	draw_set_valign(originalAlign);
}

function draw_set_halign_temp(halign, action) {
	var originalAlign = draw_get_halign();
	draw_set_halign(halign);
	action();
	draw_set_halign(originalAlign);
}

function array_insert_at(array, index, itemToInsert) {
	var length = array_length(array) + 1;
	var itemToShift = itemToInsert;
	for (var i = index; i < length; i++) {
		var currentItem = array[i];
		array[i] = itemToShift;
		itemToShift = currentItem;
	}
	
	return array;
}

function coalesce(value, fallback) {
	return value != undefined && value != noone
		? value
		: fallback;
}