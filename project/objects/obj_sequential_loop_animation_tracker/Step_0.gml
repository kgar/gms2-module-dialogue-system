if (!active) {
	exit;
}

if (frames >= nextImgFrameCount) {
	currentSubImg = (currentSubImg + 1) % subImgLength;
	frames = 0;
}
else {
	frames++;
}