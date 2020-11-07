## `Init(...)` functions for objects
In this dialogue system, I have found that there are numerous instances where objects are created first, then given data, then given the signal to start functioning normally. As I started implementing my own version of this system, I found that declaring an `Init()` function in the `Create` event of the object gives me the chance to make sure I'm requiring everything I need from the calling object.

```
// in obj_textbox_vStruct Create event

function Init(_dialogue) {
	dialogue = _dialogue;
    // Init / calculate any other one-time things that are needed
	TurnPage();
	active = true;
}
```

I like this approach. Will it work when I've got all the various optional effects in place? I'll find out before long. Here's what it looks like when `create_dialogue_vStruct`:
```
function create_dialogue_vStruct(_dialogue) {

	if(instance_exists(obj_textbox_vStruct)){ exit; }

	//Create the Textbox
	var _textbox = instance_create_layer(x,y, "Text", obj_textbox_vStruct);
	_textbox.Init(_dialogue);
	return _textbox;
}
```

## Declaring Functions in `Create`
So, I realized that User Events in these objects are really object functions that didn't have a home before more recent GML updates. Now, rather than put a block of functionality in a user event, I can simply declare a function in the object, preferably on `Create`:
```
// in obj_textbox_vStruct Create event
function TurnPage() {
	currentPage = currentPage == undefined
		? 0
		: currentPage + 1;
	
	textIndex = 0;
}
```
With this function, other lifecycle events in `obj_textbox_vStruct` can just call the function rather than doing an `event_perform(...)` call. It's far more direct and eliminates the need for explanatory comments. For example,
```
// In the code that turns the page in the dialogue:
// BEFORE
else if(page+1 < array_length_1d(text)){
			event_perform(ev_other, ev_user0);
			switch(nextline[page]){
				case -1: instance_destroy();	exit;
				case  0: page += 1;				break;
				default: page = nextline[page];
			}
			event_perform(ev_alarm, 0); // WHAT IS THIS????!!
			
		} else { event_perform(ev_other, ev_user0); instance_destroy(); }
// AFTER
else if(page+1 < array_length_1d(text)){
			event_perform(ev_other, ev_user0);
			switch(nextline[page]){
				case -1: instance_destroy();	exit;
				case  0: page += 1;				break;
				default: page = nextline[page];
			}
			TurnPage();
			
		} else { event_perform(ev_other, ev_user0); instance_destroy(); }
```

Granted, if I wanted to delay the page turn, I can still use an alarm in some more self-documenting way, such as:
```
// In Create event
function TurnPageAfterDelay(delayMs) {
    alarm0Action = {
        execute: function() {
            TurnPage();
        }
    }
    event_perform(ev_alarm, 0, delayMs);
}

// In Alarm 0
/// @description Execute Stored Action
if (alarm0Action != undefined) { // Currently not sure how to check if the alarm0Action has a value.
    alarm0Action.execute();
}

// In Step event
else if(page+1 < array_length_1d(text)){
			event_perform(ev_other, ev_user0);
			switch(nextline[page]){
				case -1: instance_destroy();	exit;
				case  0: page += 1;				break;
				default: page = nextline[page];
			}
			TurnPageAfterDelay(10); // Check out that delay!
			
		} else { event_perform(ev_other, ev_user0); instance_destroy(); }
```
Hmm, this causes a problem. If the object (or other objects) schedule multiple alarms, the alarm0Action could be overwritten...

This got me thinking about an alarm0ActionQueue, but even then, if longer alarms are set first, followed by shorter alarms, things could be dequeued out of their intended order. We've got like 12 alarms we can use. Perhaps trying to turn alarm0 into a fractal universe is not worth the trouble...