# Choice Cursor Management with Overflow

When there are more options than there is vertical space in the textbox, then rather than moving the cursor, I should scroll the text itself.

Below are some use cases I'll try to cover. I'm thinking I will need to perform all of these behaviors when interacting with player choice selection.

## Use Case: Scrolling down

When the cursor is on the bottom line and there is still at least one option beyond the current option, when the user scrolls down, then
- the cursor should not move
- the yOffset for the dialogue choices should have one line subtracted from it
- the choice index should increment  

## Use Case: Scrolling up

When the cursor is on the top line and there is still at least one option above the current option, when the user scrolls up, then
- the cursor should not move
- the yOffset for the dialogue choices should have one line added to it
- the choice index should decrement

## Use Case: Wrapping to top

When the cursor is on the bottom line and there are no further options below the currently highlighted one, when the user scrolls down, then
- the cursor should move to the first line
- the yOffset should be zeroed out
- the choice index should be set to 0

## Use Case: Wrapping to bottom

When the cursor is on the top line and there are no further options above the currently highlighted one, when the user scrolls up, then
- the cursor should move to the last line
- the yOffset should be set to the max value (max lines - 1)
- the choice index should be set to the last one (length - 1)

## Use Cases: When there's no overflow

When there is no overflow with dialogue choices, the existing behavior, with wraparound, should work as before, where the cursor and the dialogue choice have the same index.