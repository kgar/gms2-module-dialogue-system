/// @description Increment

if (specIndex < specsLength - 1) {
	specIndex = min(specIndex + dialogueSpeed, specsLength - 1);
	framesSinceTypeWritingCompleted = 0;
} else {
	framesSinceTypeWritingCompleted++;
}
	
dialogueSpeed = specIndex < specsLength
	? currentCharacterSpecs[specIndex].speed
	: dialogueSpeed;
