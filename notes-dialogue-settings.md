## So, about dialogue settings

My current setup puts the majority of the difficulty onto the code that creates dialogue specs. After that, rendering is simply a matter of applying the specs, setting colors and fonts, and applying various effects with trig / obj variables.

I have found that adding new effects is a fairly localized and easygoing thing. I don't think the code would scale well if I needed to add lots of effects, though. There is one big spec creation loop, and there is one big text drawing loop with a switch.

I've been puzzling about how to make such a setup more flexible for adding new effects, but I think more than anything, me going through this step-by-step is very useful in helping me to learn the skills needed for tailoring a solution for any given game. Even if I leaned on this same basic setup for various games, it's a great way to bootstrap a project, I think.

## Can I make it even bootstrappier?

Question I needed answered: is there a max game time in GMS?

I suppose that's something I shouldn't really worry about... not really... But let's calculate! The game timer value is a double.

Oof. I started to do the math, but we're talking astronomically large, like 2^1023 microseconds, or apparently 8.988466e+302 seconds, or 1.498078e+301 minutes, or 2.496796e+299 hours, or 1.040332e+298 days... there's plenty of time for me to use the game timer when doing text calculations.

I wonder what would happen in a GMS game when the clock exceeds the max. Is that even possible with frame skipping?
