export enum DialogueType {
  Normal,
  Choice
}

export enum TextEffect {
  Normal,
  Shakey,
  Wave,
  ColorShift,
  WaveAndColorShift,
  Spin,
  Pulse,
  Flicker
}

export enum DialogueJumpType {
  AbsoluteIndex,
  RelativeIndex,
  UniqueId,
  ExitDialogue
}

export interface DialogueJump {
  jumpType: DialogueJumpType;
  value?: string | number;
}

export interface DialogueChoice {
  text: string;
  jump?: DialogueJump;
  script?: () => void;
  getInterpolationData?: () => object;
}

export interface DialoguePortrait {
  idle?: string;
  idleFps?: string;
  subImg?: number;
  speaking?: string;
  speakingFps?: string;
  invert?: boolean;
}

export interface DialogueChoices {
  type: DialogueType.Choice;
  text?: string;
  choices: DialogueChoice[];
  speaker?: number;
  effects?: DialogueTextEffect[];
  textColors?: TextColor[];
  onPageOpen?: (instance: number) => void;
  onPageTurn?: (instance: number) => void;
  emotion?: number;
  emote?: number;
  textSpeed?: TextSpeed[];
  textFont?: TextFont[];
  id?: string;
  name?: string;
  portrait?: DialoguePortrait;
  showThisPage?: (instance: number) => boolean;
}

export interface TextColor {
  index: number;
  color: number;
}

export interface TextSpeed {
  index: number;
  speed: number;
}

export interface TextFont {
  index: number;
  font: number;
}

export interface DialogueTextEffect {
  index: number;
  effect: TextEffect;
}

export interface DialogueMessage {
  type: DialogueType.Normal;
  text: string;
  speaker?: number;
  effects?: DialogueTextEffect[];
  onPageOpen?: (instance: number) => void;
  onPageTurn?: (instance: number) => void;
  textColors?: TextColor[];
  emotion?: number;
  emote?: number;
  textSpeed?: TextSpeed[];
  textFont?: TextFont[];
  uniqueId?: string;
  name?: string;
  portrait?: DialoguePortrait;
  jump?: DialogueJump;
  getInterpolationData?: () => object;
  showThisPage?: (instance: number) => boolean;
}

export type DialogueEntry = DialogueChoices | DialogueMessage;
export type Dialogue = DialogueEntry[];

export declare var id: number,
  create_instance_layer: Function,
  obj_emote: number,
  obj_player: number,
  obj_examplechar: number,
  c_lime: number,
  c_white: number,
  c_yellow: number,
  c_aqua: number,
  c_fuschia: number,
  change_variable: Function,
  obj_emote_vStruct: number,
  global: any,
  fnt_chiller: number,
  audio_play_sound: (soundid: number, priority: number, loops: boolean) => void,
  snd_item_award: number;
