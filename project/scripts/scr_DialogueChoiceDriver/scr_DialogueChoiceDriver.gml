function DialogueChoiceDriver(_choices, _x1, _y1, _width, _height, _lineHeight) constructor {
	choices = _choices;
	choicesLength = array_length(choices);
	lineHeight = _lineHeight;
	currentChoiceIndex = 0;
	choiceSurface = -1;
	choiceScrollIndicatorWidth = 25;
	choiceScrollIndicatorHeight = 20;
	choiceSoundPriority = 5;
	choiceTextColor = c_yellow;
	choicePointerWidth = sprite_get_width(spr_pointer);
	choicePointerRightPadding = choicePointerWidth / 2;
	choiceMaxVisibleLines = floor(_height / _lineHeight);
	choicePointerTopY = _y1 + _lineHeight / 2;
	choicePointerBottomY = choicePointerTopY + (choiceMaxVisibleLines - 1) * _lineHeight;
	targetChoicePointerX = _x1;
	targetChoicePointerY = _y1 + _lineHeight / 2;
	currentChoicePointerX = _x1;
	currentChoicePointerY = _y1 + _lineHeight / 2;
	chosen = false; // TODO: Find out if this is needed here or in the textbox
	choiceSurfaceHeight = _height;
	choiceContentHeight = 0;
	var standardSurfaceWidth = _width - choicePointerWidth - choicePointerRightPadding;
	for(var i = 0; i < choicesLength; i++) {
		choiceContentHeight += string_height_ext(choices[i].text, -1, standardSurfaceWidth);
	}
	hasChoiceHeightOverflow = choiceSurfaceHeight < choiceContentHeight;
	var effectiveScrollIndicatorWidth = hasChoiceHeightOverflow
		? choiceScrollIndicatorWidth
		: 0;
	choiceSurfaceWidth = standardSurfaceWidth - effectiveScrollIndicatorWidth;
	choiceSurfaceX = _x1 + choicePointerWidth + choicePointerRightPadding;
	choiceSurfaceY = _y1;
	choiceSurfaceCurrentYOffset = 0;
	choiceSurfaceTargetYOffset = 0;
	choiceScrollUpIndicatorX = hasChoiceHeightOverflow ? choiceSurfaceX + choiceSurfaceWidth : undefined;
	choiceScrollUpIndicatorY = hasChoiceHeightOverflow ? choiceSurfaceY : undefined;
	choiceScrollDownIndicatorX  = hasChoiceHeightOverflow ? choiceScrollUpIndicatorX : undefined;
	choiceScrollDownIndicatorY = hasChoiceHeightOverflow ? choiceSurfaceY + choiceSurfaceHeight - choiceScrollIndicatorWidth : undefined;
	choiceScrollTextColor = make_color_rgb(210, 210, 210);
	choiceCanScrollDown = undefined;
	choiceCanScrollUp = undefined;
	
	function has_next_choice() {
		return currentChoiceIndex < choicesLength - 1;
	}

	function get_choice_text_height(_index) {
		return string_height_ext(choices[_index].text, -1, choiceSurfaceWidth);
	}


	function go_to_next_choice() {
		if (!has_next_choice()) {
			currentChoiceIndex = 0;
			targetChoicePointerY = choicePointerTopY;
			choiceSurfaceTargetYOffset = 0;
			refresh_scroll_indicators();
			return;
		}
	
		var currentChoiceTextHeight = get_choice_text_height(currentChoiceIndex);
		var cursorOffset = targetChoicePointerY + currentChoiceTextHeight;
		currentChoiceIndex++;
		var nextOptionHeight = get_choice_text_height(currentChoiceIndex);
		var nextOptionHasOverflow = targetChoicePointerY + nextOptionHeight > choicePointerBottomY;
		
		if (cursorOffset <= choicePointerBottomY && !nextOptionHasOverflow) {
			targetChoicePointerY += currentChoiceTextHeight;
		}
		else {
			targetChoicePointerY += currentChoiceTextHeight;
			var nextChoiceVisibleLineCount = 0;
			var pointerYTemp = targetChoicePointerY;
			while (pointerYTemp <= choicePointerBottomY) {
				pointerYTemp += lineHeight;
				nextChoiceVisibleLineCount++;
			}
		
			choiceSurfaceTargetYOffset = choiceSurfaceTargetYOffset - nextOptionHeight + nextChoiceVisibleLineCount * lineHeight;
			targetChoicePointerY = targetChoicePointerY - nextOptionHeight + nextChoiceVisibleLineCount * lineHeight;
		}
		
		refresh_scroll_indicators();
	}
	
	function has_previous_choice() {
		return currentChoiceIndex > 0;
	}
	
	function refresh_scroll_indicators() {
		choiceCanScrollDown = hasChoiceHeightOverflow && abs(choiceSurfaceTargetYOffset) + choiceSurfaceHeight < choiceContentHeight;
		choiceCanScrollUp = hasChoiceHeightOverflow && choiceSurfaceTargetYOffset != 0;
	}
	
	function go_to_previous_choice() {
		if (!has_previous_choice()) {
			var origin = currentChoiceIndex;
			var destination = choicesLength - 1;
			var distance = abs(destination - origin);
		
			repeat(distance) {
				go_to_next_choice();
			}
		
			refresh_scroll_indicators();
			return;
		}
	
		currentChoiceIndex--;	
	
		var previousChoiceHeight = get_choice_text_height(currentChoiceIndex);

		if (targetChoicePointerY - previousChoiceHeight >= choicePointerTopY) {
			targetChoicePointerY -= previousChoiceHeight;
		}
		else {
			var originalY = targetChoicePointerY;
			targetChoicePointerY -= previousChoiceHeight;
			var visibleLinesInTargetChoice = 0;
			var pointerYTemp = targetChoicePointerY;
			while (pointerYTemp < originalY) {
				visibleLinesInTargetChoice += pointerYTemp >= choicePointerTopY
					? 1
					: 0;
				pointerYTemp += lineHeight;
			}
	
			choiceSurfaceTargetYOffset = choiceSurfaceTargetYOffset + previousChoiceHeight - visibleLinesInTargetChoice * lineHeight;
			targetChoicePointerY = targetChoicePointerY + previousChoiceHeight - visibleLinesInTargetChoice * lineHeight;
		}
		
		refresh_scroll_indicators();
	}
	
	function _draw_gui() {
		if (!surface_exists(choiceSurface)) {
			choiceSurface = surface_create(choiceSurfaceWidth, choiceSurfaceHeight);
		}
	
		choiceSurfaceCurrentYOffset = lerp(coalesce(choiceSurfaceCurrentYOffset, choiceSurfaceTargetYOffset), choiceSurfaceTargetYOffset, 0.25);
	
		surface_set_target(choiceSurface);
	
		draw_clear_alpha(c_white, 0);
	
		var drawChoiceX = 0;
		var drawChoiceY = 0;
		var choiceOffsetY = 0;
	
		for (var i = 0; i < choicesLength; i++) {
			var choice = choices[i];
			var isSelected = currentChoiceIndex == i;
			var color = isSelected ? choiceTextColor : c_white /* TODO: Eliminate this hardcodedness */;
			draw_text_ext_color(drawChoiceX, drawChoiceY + choiceOffsetY + choiceSurfaceCurrentYOffset, choice.text, lineHeight, choiceSurfaceWidth, color, color, color, color, 1);
			choiceOffsetY += string_height_ext(choice.text, lineHeight, choiceSurfaceWidth);
		}
	
		surface_reset_target();
		draw_surface(choiceSurface, choiceSurfaceX, choiceSurfaceY);
	
		// Draw Pointer
		currentChoicePointerX = lerp(coalesce(currentChoicePointerX, targetChoicePointerX), targetChoicePointerX, 0.25);
		currentChoicePointerY = lerp(coalesce(currentChoicePointerY, targetChoicePointerY), targetChoicePointerY, 0.25);
		var pointerShift = dsin(current_time / 2);
		draw_sprite(spr_pointer, 0, currentChoicePointerX + pointerShift, currentChoicePointerY);
	
		// Draw Indicators
		if (hasChoiceHeightOverflow) {
			// Scroll Up
		
			var choiceScrollIndicatorArrowPadding = choiceScrollIndicatorWidth / 5;
			if (choiceCanScrollUp) {
				draw_triangle_color(
					// Top center
					choiceScrollUpIndicatorX + choiceScrollIndicatorWidth / 2,
					choiceScrollUpIndicatorY + choiceScrollIndicatorArrowPadding,
					// Bottom left
					choiceScrollUpIndicatorX + choiceScrollIndicatorArrowPadding,
					choiceScrollUpIndicatorY + choiceScrollIndicatorHeight - choiceScrollIndicatorArrowPadding,
					// Bottom right
					choiceScrollUpIndicatorX + choiceScrollIndicatorWidth - choiceScrollIndicatorArrowPadding,
					choiceScrollUpIndicatorY + choiceScrollIndicatorHeight - choiceScrollIndicatorArrowPadding,
					choiceScrollTextColor, choiceScrollTextColor, choiceScrollTextColor, false
				);
			}
		
			if (choiceCanScrollDown) {
				draw_triangle_color(
					// Top left
					choiceScrollDownIndicatorX + choiceScrollIndicatorArrowPadding,
					choiceScrollDownIndicatorY + choiceScrollIndicatorArrowPadding,
					// Top right
					choiceScrollDownIndicatorX + choiceScrollIndicatorWidth - choiceScrollIndicatorArrowPadding,
					choiceScrollDownIndicatorY + choiceScrollIndicatorArrowPadding,
					// Bottom center
					choiceScrollDownIndicatorX + choiceScrollIndicatorWidth / 2,
					choiceScrollDownIndicatorY + choiceScrollIndicatorHeight - choiceScrollIndicatorArrowPadding,
					choiceScrollTextColor, choiceScrollTextColor, choiceScrollTextColor, false
				);
			}
		}
	}
	
	function _destroy() {
		surface_free(choiceSurface);
	}
	
	
	refresh_scroll_indicators();
}