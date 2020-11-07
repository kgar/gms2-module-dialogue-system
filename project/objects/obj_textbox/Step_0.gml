/// @description Handle User Input

switch (dialogueEntry.type) {
	case DialogueType.Normal:
	
		if (!keyboard_check_pressed(interactKey)) return;
	
		if (is_finished_type_writing()) {
			turn_page();
		} else if (can_skip_to_end_of_text()) {
			skip_to_end_of_text();
		}
		break;
	case DialogueType.Choice:
		if (chosen) exit;
		
		var finishedTypeWriting = is_finished_type_writing();
		if (keyboard_check_pressed(interactKey)) {
			
			if (finishedTypeWriting && framesSinceTypeWritingCompleted < postTypeWriteDelayBeforeInteraction) {
				exit;
			}
			else if (finishedTypeWriting) {	
				// Process input
				chosen = true;
				audio_play_sound(choiceSelectSound, choiceSoundPriority, false); 
				delayedAction = process_choice;
				alarm[0] = 10;			
			} else if (can_skip_to_end_of_text()) {
				skip_to_end_of_text();
			}
			
			exit;
		}
		
		if (!finishedTypeWriting) exit;
		
		if (keyboard_check_pressed(choiceMoveDownKey)) {
			audio_play_sound(choiceChangeSound, choiceSoundPriority, false);
			choiceDriver.go_to_next_choice();
		}
		else if (keyboard_check_pressed(choiceMoveUpKey)) {
			audio_play_sound(choiceChangeSound, choiceSoundPriority, false);
			choiceDriver.go_to_previous_choice();
		}
		
		
		break;
	default:
		throw "Invalid DialogueType";
	break;
}