import { Dialogue, DialogueType } from "./dialogue-models";

var choicesTest: Dialogue = [
  // 1 line
  {
    type: DialogueType.Choice,
    choices: [{ text: "Option 1" }]
  },
  // All lines full
  {
    type: DialogueType.Choice,
    choices: [
      { text: "Option 1" },
      { text: "Option 2" },
      { text: "Option 3" },
      { text: "Option 4" }
    ]
  },
  // All lines full; first option 2 lines long
  {
    type: DialogueType.Choice,
    choices: [
      { text: "Option 1. Option 1. Option 1. Option 1. Option 1. Option 1." },
      { text: "Option 2" },
      { text: "Option 3" }
    ]
  },
  // All lines full; second option 2 lines long
  {
    type: DialogueType.Choice,
    choices: [
      { text: "Option 1" },
      { text: "Option 2. Option 2. Option 2. Option 2. Option 2. Option 2." },
      { text: "Option 3" }
    ]
  },
  // All lines full; last option 2 lines long
  {
    type: DialogueType.Choice,
    choices: [
      { text: "Option 1" },
      { text: "Option 2" },
      { text: "Option 3. Option 3. Option 3. Option 3. Option 3. Option 3." }
    ]
  },
  // Overflow with 1-liners
  {
    type: DialogueType.Choice,
    choices: [
      { text: "Option 1" },
      { text: "Option 2" },
      { text: "Option 3" },
      { text: "Option 4" },
      { text: "Option 5" }
    ]
  },
  // Overflow with last option 2-lines
  {
    type: DialogueType.Choice,
    choices: [
      { text: "Option 1" },
      { text: "Option 2" },
      { text: "Option 3" },
      { text: "Option 4. Option 4. Option 4. Option 4. Option 4. Option 4." }
    ]
  },
  // Overflow wth middle option 2-lines
  {
    type: DialogueType.Choice,
    choices: [
      { text: "Option 1" },
      { text: "Option 2" },
      { text: "Option 3. Option 3. Option 3. Option 3. Option 3. Option 3." },
      { text: "Option 4" }
    ]
  },
  {
    type: DialogueType.Choice,
    choices: [
      { text: "Option 1" },
      { text: "Option 2. Option 2. Option 2. Option 2. Option 2." },
      { text: "Option 3" },
      { text: "Option 4" }
    ]
  },
  // Overflow with first option 2-lines
  {
    type: DialogueType.Choice,
    choices: [
      { text: "Option 1. Option 1. Option 1. Option 1. Option 1." },
      { text: "Option 2" },
      { text: "Option 3" },
      { text: "Option 4" }
    ]
  },
  // Overflow with multiple multi-line choices
  {
    type: DialogueType.Choice,
    choices: [
      { text: "Option 1. Option 1. Option 1. Option 1. Option 1." },
      { text: "Option 2" },
      { text: "Option 3. Option 3. Option 3. Option 3. Option 3." },
      { text: "Option 4. Option 4. Option 4. Option 4. Option 4." }
    ]
  }
];
