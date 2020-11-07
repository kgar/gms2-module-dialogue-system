active = false;

animationFps = undefined;
currentSubImg = undefined;
subImgLength = undefined;
frames = undefined;
nextImgFrameCount = undefined;

function init(_animationFps, _subImgLength) {
	animationFps = _animationFps;
	currentSubImg = 0;
	subImgLength = _subImgLength;
	nextImgFrameCount = room_speed / animationFps;
	active = true;
	frames = 0;
}