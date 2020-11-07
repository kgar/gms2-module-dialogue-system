function CharacterSpec() constructor {
	character = "";
	width = -1;
	xOffset = 0;
	yOffset = 0;
	effect = TextEffect.Normal;
	color = undefined;
	font = undefined;
	speed = 1;
}

function copy_character_spec(spec) {
	var copy = new CharacterSpec();
	copy.character = spec.character;
	copy.width = spec.width;
	copy.xOffset = spec.xOffset;
	copy.yOffset = spec.yOffset;
	copy.effect = spec.effect;
	copy.color = spec.color;
	copy.font = spec.font;
	copy.speed = spec.speed;
	return copy;
}

function range_map_create(struct, rangeArrayName, valueName) {
	var effectsMap = ds_map_create();
	var array = variable_struct_get(struct, rangeArrayName);
	if (array == undefined) {
		return effectsMap;
	}
	var arrayLength = array_length(array);
	for (var i = 0; i < arrayLength; i++) {
		var entry = array[i];
		ds_map_set(effectsMap, entry.index, variable_struct_get(entry, valueName)); 
	}
	return effectsMap;
}


function character_specs_create(dialogueEntry, textAreaWidth, _caller, _defaultFont, _textColor) {
	// Offsets and positioning setup
	var currentXOffset = 0;
	var currentYOffset = 0;
	var originalFont = _defaultFont;
	draw_set_font(_defaultFont);
	var lineHeight = string_height("M");
	var mostRecentSpace = -1;
	var characterInsertCount = 0;
		
	// Effects setup
	var currentEffect = TextEffect.Normal;
	var effectsMap = range_map_create(dialogueEntry, "effects", "effect");

	// Color setup
	var currentColor = _textColor;
	var colorMap = range_map_create(dialogueEntry, "textColors", "color");
		
	// Font setup
	var currentFont = originalFont;
	var fontMap = range_map_create(dialogueEntry, "textFont", "font");
		
	// Speed setup
	var currentSpeed = 1;
	var speedMap = range_map_create(dialogueEntry, "textSpeed", "speed");
		
	// Create Specs
	var characterSpecs = [];
	var currentText = dialogueEntry.text;
	var textLength = string_length(currentText);
		
	// Interpolation Data
	var interpolationData = variable_struct_exists(dialogueEntry, "getInterpolationData")
		? dialogueEntry.getInterpolationData(_caller)
		: {};
	var interpolationSpec = undefined;
	var indexAfterInterpolatedValue = undefined;
		
	for (var i = 0; i < textLength + characterInsertCount; i++) {
		var spec = new CharacterSpec();
		spec.color = currentColor;
		spec.character = string_char_at(currentText, i + 1);
			
		if (spec.character == " ") {
			mostRecentSpace = i;
		}
			
		// Handle effects
		currentEffect = coalesce(effectsMap[? i - characterInsertCount], currentEffect);
		spec.effect = currentEffect;
			
		// Handle fonts
		currentFont = coalesce(fontMap[? i - characterInsertCount], currentFont);
		spec.font = currentFont;
			
		// Handle colors
		currentColor = coalesce(colorMap[? i - characterInsertCount], currentColor);
		spec.color = currentColor;
			
		// Handle speeds
		currentSpeed = coalesce(speedMap[? i - characterInsertCount], currentSpeed)
		spec.speed = currentSpeed;
			
		// Handle interpolated data
		if (i < indexAfterInterpolatedValue) {
			var specCharacter = spec.character;
			spec = copy_character_spec(interpolationSpec);
			spec.character = specCharacter;
		}
		else if (spec.character == "$" && string_char_at(currentText, i + 2) == "{") {
			var interpolationIndex = i + 2;
			var interpolationVariableName = "";
			while (interpolationIndex < textLength) {
				// Find termination character "}"
				var interpolationCharacter = string_char_at(currentText, interpolationIndex + 1);
				if (interpolationCharacter == "}") {
					break;
				}
					
				interpolationVariableName += interpolationCharacter;
					
				interpolationIndex++;
			}
				
			if (!variable_struct_exists(interpolationData, interpolationVariableName)) {
				throw "Interpolation data required for interpolated string.\nText: " + currentText + 
				"\nMissing variable: " + interpolationVariableName;
			}
				
			var valueToInterpolate = string(variable_struct_get(interpolationData, interpolationVariableName));
			var interpolationTagLength = string_length(interpolationVariableName) + 3;
			var valueToInterpolateLength = string_length(valueToInterpolate);
			characterInsertCount += valueToInterpolateLength - interpolationTagLength;
			interpolationSpec = spec;
			indexAfterInterpolatedValue = i + valueToInterpolateLength;
				
			currentText = string_replace(currentText, "${" + interpolationVariableName + "}", valueToInterpolate);
				
			spec.character = string_char_at(valueToInterpolate, 1);
		}
			
		var tempFont = draw_get_font();
		draw_set_font(spec.font);
		spec.xOffset = currentXOffset;
		spec.yOffset = currentYOffset;
		spec.width = string_width(spec.character);
		draw_set_font(tempFont);
			
		characterSpecs[i] = spec;
		currentXOffset += spec.width;
			
		// Handle escaped newlines
		if (spec.character == "\n") {
			currentYOffset += lineHeight;
			currentXOffset = 0;
			continue;
		}
			
		// Handle automatic newlines
		if (currentXOffset > textAreaWidth) {
			currentXOffset = 0;
			currentYOffset += lineHeight;
				
			var breakWord = mostRecentSpace == -1;
			var startOfNewline = breakWord
				? i - 1 // Take the last character on the current line, and the current over-wide character
				: mostRecentSpace + 1; // Take the whole word
				
			// Backfill new yOffset from last-known space
			for (var j = startOfNewline; j <= i; j++) {
				var specToMoveToNewLine = characterSpecs[j];
				specToMoveToNewLine.yOffset = currentYOffset;
				specToMoveToNewLine.xOffset = currentXOffset;
				currentXOffset += specToMoveToNewLine.width;
			}
				
			// Insert hyphen if breaking a word
			if (breakWord) {
				currentText = string_insert("-", currentText, startOfNewline);
				var lastCharacterOnWordBreakLine = characterSpecs[startOfNewline - 1];
				var hyphenSpec = copy_character_spec(lastCharacterOnWordBreakLine);
				hyphenSpec.xOffset = lastCharacterOnWordBreakLine.xOffset + lastCharacterOnWordBreakLine.width;
				hyphenSpec.character = "-";
				characterSpecs = array_insert_at(characterSpecs, startOfNewline, hyphenSpec);
				i++; // Skip forward by 1 to account for inserted character
				characterInsertCount++; // Increment inserted character count to ensure the loop covers all remaining text
			}
				
			mostRecentSpace = -1;
		}
	}
		
	ds_map_destroy(effectsMap);
	ds_map_destroy(colorMap);
	ds_map_destroy(fontMap);
	ds_map_destroy(speedMap);
		
	draw_set_font(originalFont);
	
	return characterSpecs;
}