active = false;

// Dialogue Settings
dialogue = undefined;
dialogueEntry = undefined;
currentPage = undefined;
currentText = undefined;

// Normal Dialogue
dialogueSpeed = 1;
specsLength = undefined;
currentCharacterSpecs = undefined;
specIndex = undefined;
framesSinceTypeWritingCompleted = undefined;
postTypeWriteDelayBeforeInteraction = 15;

// Choice Dialogue
chosen = false;
choiceSoundPriority = 5;
choiceChangeSound = snd_moveselect;
choiceSelectSound = snd_select;
choiceDriver = undefined;

// Input
interactKey = global.interactKey;
choiceMoveUpKey = vk_up;
choiceMoveDownKey = vk_down;

// Delayed actions
delayedAction = undefined;

// Draw Settings
textColor = c_white;
lineHeight = undefined;
guiWidth = undefined;
guiHeight = undefined;
textboxPaddingX = undefined;
textboxPaddingY = undefined;
textboxWidth = undefined;
textboxMaxLinesOfText = undefined;
textboxHeight = undefined;
textboxPositionX = undefined;
textboxPositionY = undefined;

// Portrait
portraitSpriteIdle = undefined;
portraitSubImg = undefined;
portraitSpriteSpeaking = undefined;
portraitX = undefined;
portraitY = undefined;
portraitWidth = undefined;
portraitPaddingX = undefined;
portraitWidthAndPadding = undefined;
portraitSide = undefined;
portraitXScale = 0;
portraitSpeakAnimationTracker = undefined; // TODO: Destroy and recreate this for the lifetime of the textbox; if not undefined, then destroy on object destruction.

// Nameplate
nameplateName = undefined;
nameplateX = undefined;
nameplateY = undefined;
nameplateWidth = undefined;
nameplateHeight = undefined;
nameplateXPadding = undefined;
nameplateYPadding = undefined;
nameplateXOffset = 0;
nameplateYOffset = 0;

// Effect Settings
waveEffectAmplitude = 4;
waveEffectFrequency = 6;

function init(_dialogue, _caller, _dialogueFont) {
	dialogue = _dialogue;
	caller = _caller;
	dialogueFont = coalesce(_dialogueFont, fnt_dialogue);
	
	draw_set_font_temp(dialogueFont, function() {
		lineHeight = string_height("M");
	});
	
	guiWidth = display_get_gui_width();
	guiHeight = display_get_gui_height();
	textboxPaddingX = lineHeight * 0.5;
	textboxPaddingY = lineHeight * 0.3;
	textboxWidth = guiWidth - lineHeight * 0.5;
	textboxMaxLinesOfText = 4;
	textboxHeight = lineHeight * textboxMaxLinesOfText + textboxPaddingY * 2;
	textboxPositionX = (guiWidth - textboxWidth) / 2;
	textboxPositionY = guiHeight - textboxHeight - lineHeight * 0.3;
	portraitPaddingX = lineHeight * 0.5;
	nameplateXPadding = lineHeight * 0.25;
	nameplateYPadding = lineHeight * 0.15;

	turn_page();
	active = true;
}

/// @description Turn the page
/// @param index  optional field specifying the absolute index to change the page to.
function turn_page() {
	
	var absoluteIndex = argument_count > 0 ? argument[0] : undefined;
	
	if (absoluteIndex != undefined) {
		currentPage = absoluteIndex;
	} 
	else {
		currentPage = currentPage == undefined
			? 0
			: currentPage + 1;	
	}
	
	#region Disposal of prior resources
	if (portraitSpeakAnimationTracker != undefined) {
		instance_destroy(portraitSpeakAnimationTracker);
		portraitSpeakAnimationTracker = undefined;
	}
	#endregion
		
	if (dialogueEntry != undefined && variable_struct_exists(dialogueEntry, "onPageTurn")) {
		dialogueEntry.onPageTurn(caller);
	}
		
	if (currentPage >= array_length(dialogue)) {
		instance_destroy();
		return;
	}
	
	dialogueSpeed = 1;
	
	dialogueEntry = dialogue[currentPage];
	
	if (variable_struct_exists(dialogueEntry, "showThisPage") && !dialogueEntry.showThisPage(caller)) {
		turn_page();
		return;
	}
	
	if (dialogueEntry != undefined && variable_struct_exists(dialogueEntry, "onPageOpen")) {
		dialogueEntry.onPageOpen(caller);
	}
	
	currentText = coalesce(variable_struct_get(dialogueEntry, "text"), "");
	
	specIndex = 0;
	framesSinceTypeWritingCompleted = 0;

	// TODO: Throw this right into a struct and calculate everything on construction :O
	var portrait = variable_struct_get(dialogueEntry, "portrait");
	
	portraitSpriteIdle = portrait != undefined 
		? asset_get_index(portrait.idle) 
		: undefined;
		
	portraitSubImg = portrait != undefined 
		? coalesce(variable_struct_get(portrait, "subImg"), 0) 
		: undefined;

	portraitSpriteSpeaking = portrait != undefined && variable_struct_exists(portrait, "speaking")
		? asset_get_index(variable_struct_get(portrait, "speaking"))
		: undefined;
		
	if (portraitSpriteSpeaking != undefined) {
		portraitSpeakAnimationTracker = instance_create_layer(0, 0, "Instances", obj_sequential_loop_animation_tracker);
		
		var portraitSpriteSpeakingFps = portrait != undefined && variable_struct_exists(portrait, "speakingFps")
			? variable_struct_get(portrait, "speakingFps")
			: 6;
		
		portraitSpeakAnimationTracker.init(portraitSpriteSpeakingFps, sprite_get_number(portraitSpriteSpeaking));
	}
	
	portraitWidth = portraitSpriteIdle != undefined 
		? sprite_get_width(portraitSpriteIdle) 
		: 0;
	
	portraitSide = portrait != undefined 
		? coalesce(variable_struct_get(portrait, "side"), PortraitSide.Left) 
		: PortraitSide.Left;
	
	if (portrait != undefined && portraitSide == PortraitSide.Left) {
		portraitX = textboxPositionX + portraitPaddingX + portraitWidth / 2;
	} else if (portrait != undefined && portraitSide == PortraitSide.Right) {
		portraitX = textboxPositionX + textboxWidth - portraitPaddingX - portraitWidth / 2;
	} else {
		portraitX = undefined;
	}
	
	portraitY = portrait != undefined 
		? textboxPositionY + textboxHeight / 2 
		: undefined;
	
	portraitWidthAndPadding = portrait != undefined 
		? portraitWidth + portraitPaddingX * 2 
		: 0;
	
	portraitXScale = portrait != undefined && variable_struct_get(portrait, "invert") == true
		? -1
		: 1;
	
	
	draw_set_font_temp(dialogueFont, function() {				
		// TODO: Put nameplates in a struct; name is required parameter; portrait struct is optional parameter
		nameplateName = variable_struct_get(dialogueEntry, "name");
		nameplateHeight = nameplateName != undefined ? lineHeight + nameplateYPadding * 2 : undefined;
		nameplateWidth = nameplateName != undefined ? string_width(nameplateName) + nameplateXPadding * 2 : undefined;
		// TODO: Clean this up! This is a mess! Perhaps use some functions when this is extracted to its own nameplate struct...
		nameplateX = portraitSide == PortraitSide.Right
			? (nameplateName != undefined ? textboxPositionX + textboxWidth - nameplateWidth - nameplateXOffset : undefined)
			: (nameplateName != undefined ? textboxPositionX + nameplateXOffset : undefined);
		nameplateY = nameplateName != undefined ? textboxPositionY - nameplateHeight + nameplateYOffset: undefined;
				
		var textAreaWidth = textboxWidth - textboxPaddingX * 2 - portraitWidthAndPadding;
		
		currentCharacterSpecs = currentText != "" 
			? character_specs_create(
				dialogueEntry, 
				textAreaWidth,
				caller,
				dialogueFont,
				textColor)
			: [];
		
		specsLength = array_length(currentCharacterSpecs);
		
		if (dialogueEntry.type == DialogueType.Choice) {
			chosen = false;
			
			var effectivePortraitLeftPadding = portraitSide == PortraitSide.Left
				? portraitWidthAndPadding
				: 0;
			var effectivePortraitRightPadding = portraitSide == PortraitSide.Right
				? portraitWidthAndPadding
				: 0;
			var lastTextLineYOffset = specsLength > 0 ? currentCharacterSpecs[specsLength - 1].yOffset + lineHeight : 0;
			var height = textboxHeight - textboxPaddingY * 2 - lastTextLineYOffset;
			var width = textboxWidth - textboxPaddingX * 2 - effectivePortraitLeftPadding - effectivePortraitRightPadding;
			var x1 = textboxPositionX + textboxPaddingX + effectivePortraitLeftPadding;
			var y1 = textboxPositionY + textboxHeight - height - textboxPaddingY;
			
			if (choiceDriver != undefined) {
				choiceDriver._destroy();
			}
			
			choiceDriver = new DialogueChoiceDriver(
				dialogueEntry.choices, 
				x1,
				y1,
				width,
				height,
				lineHeight);	
		}
	});	
}

function find_page_index_by_unique_id(uniqueId) {
	var totalPages = array_length(dialogue);
	for (var i = 0; i < totalPages; i++) {
		var dialogueEntryToCheck = dialogue[i];
		var pageUniqueId = variable_struct_get(dialogueEntryToCheck, "uniqueId");
		if (uniqueId == pageUniqueId) return i;
	}
	return undefined;
}

function process_choice() {
	// Get choice object based on chosen index
	var choice = dialogueEntry.choices[choiceDriver.currentChoiceIndex];
	
	// Optionally execute associated script
	var action = variable_struct_get(choice, "script");
	if (action != undefined) {
		action();
	}
	
	// Optionally adjust custom page turn; else, turn page normally
	var jump = variable_struct_get(choice, "jump");
	if (jump != undefined) {
		switch(jump.jumpType) {
			case DialogueJumpType.AbsoluteIndex:
				turn_page(jump.value);
				break;
			case DialogueJumpType.RelativeIndex:
				var absoluteIndex = currentPage + jump.value;
				turn_page(absoluteIndex);
				break;
			case DialogueJumpType.UniqueId:
				var pageSearchResult = find_page_index_by_unique_id(jump.value);
				if (pageSearchResult == undefined) {
					throw "Attempt to jump dialogue by unique ID failed. Dialogue does not contain the unique ID " + jump.value;
				}
				turn_page(pageSearchResult);
				break;
			case DialogueJumpType.ExitDialogue:
				instance_destroy();
				break;
		}
	}
	else {
		turn_page();
	}
}

function is_finished_type_writing() { 
	return specIndex >= specsLength - 1;
}

function can_skip_to_end_of_text() {
	return specIndex > 2 || specsLength <= 2;
}

function skip_to_end_of_text() {
	specIndex = specsLength - 1;
}