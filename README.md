# gms2-module-dialogue-system
A mostly-implemented dialogue system for GameMaker Studio 2 that can be plugged into a project to bootstrap functionality.

# How to Use
There's a lot of copy and paste, since this is the repo. Essentially, you need
- obj_textbox
- obj_sequential_loop_animation_tracker
- Everything in /Scripts/dialogue
- scr_utilities
- fnt_dialogue
- snd_moveselect
- snd_select
- spr_nine_panel_textbox
- spr_pointer

Once these are in your project, you can begin using the system. To create the flavor of dialogue used in the demo, use the `dialogue_create()` function and pass in a `dialogue` struct.

Maybe someday I'll have a nice, neat setup free to download/install from the GMS2 marketplace that will make this easier. I'm not there yet.

# Adapted from FriendlyCosmonaut's Dialogue System
At the time of this writing, I can still just beginning to learn GameMaker Studio 2 and game dev in general. I needed help, and I found it with a dialogue system made by FriendlyCosmonaut. I was able to adapt my own system based on hers. 

Check out [FriendlyCosmonaut's Dialogue System](https://friendlycosmonaut.itch.io/dialoguesystem) over on itch.io.

# With help from Shaun Spalding
I learned the 9-panel textbox technique from a [few](https://www.youtube.com/watch?v=BUxkMDTnxn8&t=851s) [YouTube videos](https://www.youtube.com/watch?v=Cgb6yw1WdRw&t=44s) by Shaun Spalding.
