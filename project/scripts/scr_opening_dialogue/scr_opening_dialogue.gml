function get_opening_dialogue(){
	return [
	{
	    text:
	      "Welcome to the ${superText} demo of the dialogue system! Hit 'E' to go to the next page.",
	    type: DialogueType.Normal,
	    speaker: undefined,
	    effects: [
	      { index: 0, effect: TextEffect.Shakey },
	      { index: 7, effect: TextEffect.Spin },
	      { index: 15, effect: TextEffect.Wave },
	      { index: 28, effect: TextEffect.ColorShift },
	      { index: 57, effect: TextEffect.WaveAndColorShift },
	      { index: 68, effect: TextEffect.Pulse },
	      { index: 78, effect: TextEffect.Flicker }
	    ],
	    textSpeed: [
	      { index: 0, speed: 0.2 },
	      { index: 15, speed: 2 },
	      { index: 28, speed: 0.5 },
	      { index: 57, speed: 1 }
	    ],
	    textColors: [
	      { index: 0, color: c_lime },
		  { index: 7, color: c_white },
	      { index: 15, color: c_fuchsia },
	      { index: 28, color: c_aqua },
		  { index: 78, color: make_color_rgb(220, 20, 60) }
	    ],
	    textFont: [{ index: 78, font: fnt_chiller }],
	    onPageTurn: function () {
	      show_debug_message("Secret message during dialogue! You got some opportunity here to check debug info when testing ;)");
	    },
		getInterpolationData: function() {
			return { superText: "supersupersupersupersupersupersupersupersupersupersupersupersuper" };
		}
	  },
	  {
	    text:
	      "Sometimes, I just want to ride the wave, y'all! Hyphens - and other special characters ! @ ## $ % ^ & * ( ) 0 1234567890 should wave, too!",
	    type: DialogueType.Normal,
	    effects: [
	      { index: 0, effect: TextEffect.Wave },
	      { index: 56, effect: TextEffect.WaveAndColorShift },
	      { index: 57, effect: TextEffect.Wave },
	      { index: 87, effect: TextEffect.WaveAndColorShift },
	      { index: 121, effect: TextEffect.Wave }
	    ],
		name: "Narrator",
		portrait: {
			idle: "spr_portrait_narrator",
			subImg: 0,
			speaking: "spr_portrait_narrator_speaking",
			speakingFps: 12,
			invert: true
		}
	  },
	  {
	    text:
	      "This is an example of a one-time 'text event'. It runs when the game starts.",
	    type: DialogueType.Normal,
		name: "Narrator",
		portrait: {
			idle: "spr_portrait_narrator",
			subImg: 0,
			speaking: "spr_portrait_narrator_speaking",
			speakingFps: 12,
			invert: true
		},
		showThisPage: function() {
			return global.introRestartCount <= 0;
		}
	  },
	  {
		text: "Uh, as previously stated, this is an example of a one-time 'text event'. It runs when the game starts. And I've said this ${numberOfTimesHeSaidThis} times.",
		type: DialogueType.Normal,
		name: "Narrator",
		portrait: {
			idle: "spr_portrait_narrator",
			subImg: 0,
			speaking: "spr_portrait_narrator_speaking",
			speakingFps: 12,
			invert: true
		},
		textColors: [
			{ index: 122, color: c_yellow },
			{ index: 149, color: c_white }
		],
		getInterpolationData: function() {
			return {
				numberOfTimesHeSaidThis: global.introRestartCount + 1
			}
		},
		showThisPage: function() {
			return global.introRestartCount > 0;
		}
	  },
	  {
	    text:
	      "Hit 'Space' to make a player monologue happen. And 'D' to toggle debug.",
	    type: DialogueType.Normal,
	    speaker: undefined,
	    effects: [{ index: 0, effect: TextEffect.ColorShift }],
	    uniqueId: "FullOnRainbowText",
		name: "The Other Narrator",
		portrait: {
			idle: "spr_portrait_other_narrator",
			subImg: 0,
			speaking: "spr_portrait_other_narrator_speaking",
			speakingFps: 6,
			side: PortraitSide.Right
		}
	  },
	  {
	    text: "Do you want to start over?",
	    type: DialogueType.Choice,
	    textColors: [
	      { index: 15, color: c_yellow },
	      { index: 25, color: c_white }
	    ],
	    choices: [
	      {
	        text: "Yeah, sure, why not?",
	        jump: {
	          jumpType: DialogueJumpType.AbsoluteIndex,
	          value: 0
	        },
	        script: function () {
	          global.introRestartCount++;
	        }
	      },
	      {
	        text: "Ask me something else, if you don't mind."
	      }
	    ],
		name: "Narrator",
		portrait: {
			idle: "spr_portrait_narrator",
			subImg: 0,
			speaking: "spr_portrait_narrator_speaking",
			speakingFps: 12,
			invert: true
		}
	  },
	  {
	    text: "Okay, so, ... like ... what about seeing that rad rainbow again?",
	    type: DialogueType.Choice,
	    textSpeed: [
	      { index: 10, speed: 0.2 },
	      { index: 14, speed: 0.8 },
	      { index: 18, speed: 0.2 },
	      { index: 21, speed: 1 }
	    ],
		effects: [
			{ index: 46, effect: TextEffect.ColorShift },
			{ index: 57, effect: TextEffect.Normal }
		],
	    choices: [
	      {
	        text: "Fine! Show the rainbow!",
	        jump: {
	          jumpType: DialogueJumpType.UniqueId,
	          value: "FullOnRainbowText"
	        }
	      },
	      {
	        text: "Ask the previous question.",
	        jump: {
	          jumpType: DialogueJumpType.RelativeIndex,
	          value: -1
	        }
	      },
		  {
			text: "Nope. I've heard enough." ,
			jump: {
				jumpType: DialogueJumpType.ExitDialogue
			}
		  }
	    ],
		name: "The Other Narrator",
		portrait: {
			idle: "spr_portrait_other_narrator",
			subImg: 0,
			speaking: "spr_portrait_other_narrator_speaking",
	    speakingFps: 12,
			side: PortraitSide.Right
		}
	  }
	];
}