## Choices ... choices...

Wow, so many choices to make, and choices are really arbitrary until you have a game in development and a preferred workflow for content creation and game design.

## Choice 1: Next Line as direct index or as relative page ... or as named page?

Looking at the original dialogue implementation, I see that the next-line support is via direct indexing of which page to send the player to.

I've thought about this a bit... but only a bit 😁, and I think I'd be more interested in some combination of 
- Direct indexing: *when you want to jump to the beginning or end, for example*
- Relative indexing: *when you want to jump to a dialogue entry that is very close*
- Unique IDs: *when you want to jump to a dialogue entry that is further than, say, 2 entries*

If forced to choose one approach over the others, I would absolutely choose Unique IDs. There is a price to pay for traversing the array of dialogue entries, but it's not a high price, given most contiguous dialogue arrays will stay within the 10s to 100s of entries.

One of the things that puzzled me early on when thinking about dialogue trees and about how to traverse a dialogue tree, I realized that things can get out of hand really fast. For this reason, and especially with starting out and building a text-based game on a small scale, I appreciate the simplicity of the source dialogue system here. FriendlyCosmonaut has created something that not only provides immediate usefulness to game devs, but it provides so many opportunities for someone like me to learn about GMS2. I can only aspire to be the kind of game dev that she is. Incredible~! 🤩

### Enum + Struct: different types of dialogue array traversal!

Take an enum:
- DialogueJumpType
  - AbsoluteIndex // Direct indexing
  - RelativeIndex // Relative indexing
  - UniqueId // 😏

Make a global struct factory:
- DialogueJump
  - JumpType // DialogueJumpType enum
  - Value // string|number
  - Constructor: _jumpType, _value

Each choice can have an optional DialogueJump. If there's a jump, it's executed as follows:
- AbsoluteIndex: call TurnPage(...)