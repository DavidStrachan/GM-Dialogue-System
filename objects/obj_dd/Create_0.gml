/// @description Insert description here
// You can write your code in this editor

/* TEXT EFFECTS TO DO:
> (intro) Matrix text intro (I dont know how you make the characters look like they are falling)
> (intro) Random character foir a period
> (intro)  Hacked glitchy effect, random scale / x/y
> (constant effect but not as strong)  Hacked glitchy effect, random scale / x/y
*/

// SETUP DAVES DIALOGUE - CAN EDIT
frames_per_character_fast = 0
frames_per_character_fast_char = [" "];
frames_per_character_standard = 2 // all speeds can be decimal numbers i.e. 0.25 will display 4 characters a frame. 
//frames_per_character_standard_char = []; // this is everything not in one of the other arrays
frames_per_character_slow = 10
frames_per_character_slow_char = [","]
frames_per_character_very_slow = 20
frames_per_character_very_slow_char = [".","!","?"]
frames_per_character_temp = 3 // this is the speed we will use and can be temporarily changed by a style 
animate_in_frames = 45
animate_out_frames = 30
markup_character_start = "{" // I will look for this character in the text 
markup_character_end = "}" // I actually just bind this to the end of all your dialogue options 
reply_selected_start = " >> " // for the reply that is selected I will put these characters 
reply_selected_end = " << "
// positions:
pos_background_x = view_get_wport(0)/2
pos_background_y = 600
pos_text_x = pos_background_x // this is the centre and will be offset by half the text_area_width 
pos_text_y = pos_background_y-67
pos_name_x = pos_background_x+160
pos_name_y = pos_background_y-103
pos_image_left_x = pos_background_x-430
pos_image_left_y = pos_background_y-10
pos_image_right_x = pos_background_x+430
pos_image_right_y = pos_background_y-10
pos_reply_x = pos_background_x+40

line_height = 25
line_height_reply = 19
text_area_width = 680

mouse_outside_box = pos_text_y-70 // if the mouse is above this it it considered outside the text area if they click (so probabbly it will close depending on what you set)

//inputs:
keyboard_affirmative = [vk_enter,ord("E")] // any key where the player is making a positive (or progressing) action 
keyboard_negative = [vk_escape,vk_backspace] // any key where the player is making a positive (or progressing) action 
keyboard_up = [ord("W"),vk_up,vk_pageup] 
keyboard_down = [ord("S"),vk_down,vk_pagedown,vk_tab] 

gamepad_affirmative = [gp_select,gp_face1] // any key where the player is making a positive (or progressing) action 
gamepad_negative = [gp_start,gp_face2] // any key where the player is making a positive (or progressing) action 
gamepad_up = [gp_padu] 
gamepad_down = [gp_padd] 
gamepad_left_stick_on = true
gamepad_right_stick_on = true

gamepad_countdown = 0 // array of how long until you can register another joystick again 
gamepad_delay = 20 // if you push a joystick how long until it can register another input (letting go resets this)
gamepad_deadzone_inner = gamepad_get_axis_deadzone(0)
gamepad_deadzone_outer = 0.8



// SETUP DAVES DIALOGUE - DONT EDIT
display = 0 // 0=dont display, 1=animate in, 2=display, 3=animate out 
frame = 0 // how long until we bring in the next character 
dd_to_display = -1 // -1 for none, otherwise a dd_id (this is the id of the dialogue we want to display)
character_along = 1 // how many characters along have we processed
type_out_complete = false // when all the text has been animated in 
skip_typeout = false // dont individually type out every letter  
// These are the things you pass into the drawing function  
data_maintext_text[0] = "" // these are the strings we want to draw 
data_maintext_style[0] = -1 // this is the style id for each string we want to draw 
data_maintext_effect[0] = -1 // this is the effect id for each string we want to draw 
data_maintext_image[0] = -1 // this is the effect id for each string we want to draw 
data_maintext_x[0] = -1 // where to draw this
data_maintext_y[0] = -1 // 
data_maintext_line[0] = 0 // what line is this block on
//
running_x = 0 // as you are adding characters also increase this number
running_x_for_line[0] = 0 // same as running_x but resets when going to a new line 
running_y = 0
line_count = 0
block_number = 0 // we batch together all the text until the style changes, this is the block we are currently on 
animate_in_frame = 0
animate_out_frame = 0
style_last = 0 // this is set to dd_style.normal right away 
style_current = 0 // this is set to dd_style.normal right away 
effects_data[0] = 0 // any block of text can store data here about how it should be drawn, it will be reset when the dialogue is closed
selected_reply = -1 // -1 means animating in or nothing to select 
mouse_x_last = -1 // for mouse select reply  
mouse_y_last = -1 


enum dd_style { // You will want to replace this with a list of all styles you want. a style is made up of a colour, font, and maybe a style. 
	normal,
	blue,
	green,
	purple,
	purplewave,
	red,
	small,
	shake,
	underline,
	red_underline,
	green_strikethrough,
	quicktype,
	slowtype,
	effect1,
	effect2,
	effect3,
	effect4,
	effect5,
	effect6,
	effect7,
	effect8,
	effect9,
	effect10,
	effect11,
	effect12,
	effect13,
	effect14,
	effect15,
	effect16,
	effect17,
	effect18,
	effect19,
	effect20,
	effect21_a,
	effect21_b,
	effect22,
	effect23,
	effect24,
	effect25,
	effect26,
	effect27,
	shadow1,
	shadow2,
	stroke1,
	stroke2,
	intro1,
	intro2,
	intro3,
	intro4,
	intro5,
	intro6,
	intro7,
	intro8,
	intro9,
	intro10,
	intro11,
	intro12,
	intro13,
	intro14,
	whiteshadowquicktype, // just using this for twitter
	fadyblock_1,
	fadyblock_2,
	fadyblock_3,
	fadyblock_4,
	
	neweffects1,
	neweffects2,
	neweffects3,
	neweffects4,
	neweffects5,
	neweffects6,
	neweffects7,
	
	size
}

#region all of the built in effects your text can have
enum dd_effect { // These are all the built in effects that you can add to the text 
	none,
	
	underline,
	strikethrough,
	shadow1, 
	shadow2,
	stroke1,
	stroke2,
	stroke_animated,
	stroke_animated_black,
	chromatic_aberration,
	
	wobble_word, // random x,y movment on each word
	wobble_letter, // random x,y movment on each letter
	
	bounce_word, // whole section goes up and down like its being thrown up
	bounce_letter, // whole section goes up and down like its being thrown up
	mexican_wave_word, // whole section goes up and down like its being thrown up
	mexican_wave_letter, // whole section goes up and down like its being thrown up
	mexican_wave_scale, // each letter jumps scales up by a little and then reduses in size one at a time 
	mexican_wave_alpha, // each letter jumps scales up by a little and then reduses in size one at a time 
	
	rainbow_short, // each letter goes a different colour (short has less colours) 
	rainbow_long, // each letter goes a different colour 
	rainbow_animated_word, // each word changes colour over time
	rainbow_animated_letter, // each letterchanges colour over time
	
	sinewave_word_h, // each letter moves up and down in a verticle sine wave 
	sinewave_word_v, // each letter moves up and down in a verticle sine wave 
	sinewave_word_scale, // each letter moves up and down in a verticle sine wave 
	sinewave_letter_h, // each letter moves up and down in a verticle sine wave 
	sinewave_letter_v, // each letter moves up and down in a verticle sine wave 
	sinewave_letter_scale, // each letter moves up and down in a verticle sine wave 
	sinewave_word_h_slow, // each letter moves up and down in a verticle sine wave 
	sinewave_word_v_slow, // each letter moves up and down in a verticle sine wave 
	sinewave_word_scale_slow, // each letter moves up and down in a verticle sine wave 
	sinewave_letter_h_slow, // each letter moves up and down in a verticle sine wave 
	sinewave_letter_v_slow, // each letter moves up and down in a verticle sine wave 
	sinewave_letter_scale_slow, // each letter moves up and down in a verticle sine wave 
	
	rotate_smooth, // each letter rotates by about 5 degrees back and forth 
	rotate_letter_fixed, // each letter is slightly rotated and doesnt move 
	rotate_letter_shake, // each letter is slightly rotated and vibrates horizontally and vertically (but rotation doesnt change)
	popping, // each letter suddely gets bigger in scale and then slowly comes down (start on random amount) 
	beat, // suddenly get bigger and then slowly go back to normal (like a music beat)
	beatfast, // suddenly get bigger and then slowly go back to normal (like a music beat)
	heart_beat_word, // throbing like the beat of a heart beat (whole word)
	heart_beat_letter, // throbing like the beat of a heart beat (wripples down each letter at a time)
	heart_beat_alpha, // throbing like the beat of a heart beat (each letter)
	flash, // alpha goes up and down
	flicker_alpha, // 
	flicker_alpha_constant, // 
	squeeze_squish, // sine the scale up and down but make the h scale big when the v scale is small and visa versa 
	
	intro_alpha_slow, // slowly bring in the alpha 
	intro_alpha_fast, // slowly bring in the alpha 
	intro_top_with_alpha, // fall from top with alpha change
	intro_bottom_right, // slide in from bottom right
	intro_big_to_normal, // start the text big with alpha and scale down
	intro_small_to_normal, // start the text small and make bigger
	intro_fall_in, // start slow and stopping very suddely 
	intro_slide_right, // start slow and stopping very suddely 
	intro_black_to_grey, // start slow and stopping very suddely 
	intro_white_to_grey, // start slow and stopping very suddely 
	intro_red_to_grey, // start slow and stopping very suddely 
	intro_wobble, // random wobble that gets smaller and smaller
	intro_sine_v, // sine wave that gets smaller and smaller
	intro_wind_in, // go round in a circle before finding its place
	intro_chromatic_aberration, // 
	intro_big_height_small_width, // start with height=2 and width=0 and animate to 1/1
	intro_big_width_small_height, // start with width=2 and height=0 and animate to 1/1
	
	// All these look best with style_speed = 0
	block_1s, // block that all gets displayed at the same time and then waits for x seconds
	block_2s, // 2 seconds
	block_3s, // 3 seconds
	block_4s, // 4 seconds
	intro_fadein_thendull_1s, // bring in a block of text for the player to read and then dull it out for the next block @joethephish
	intro_fadein_thendull_2s, // 2 seconds
	intro_fadein_thendull_3s, // 3 seconds
	
	size,
}

// Some effects requier letters to be brought in one at a time. 
effect_letter_by_letter = array_create(dd_effect.size)
effect_letter_by_letter[dd_effect.none] = false
effect_letter_by_letter[dd_effect.underline] = false
effect_letter_by_letter[dd_effect.strikethrough] = false
effect_letter_by_letter[dd_effect.shadow1] = false
effect_letter_by_letter[dd_effect.shadow2] = false
effect_letter_by_letter[dd_effect.stroke1] = false
effect_letter_by_letter[dd_effect.stroke2] = false
effect_letter_by_letter[dd_effect.stroke_animated] = false
effect_letter_by_letter[dd_effect.stroke_animated_black] = false
effect_letter_by_letter[dd_effect.wobble_word] = false
effect_letter_by_letter[dd_effect.wobble_letter] = true
effect_letter_by_letter[dd_effect.bounce_word] = false
effect_letter_by_letter[dd_effect.bounce_letter] = true
effect_letter_by_letter[dd_effect.mexican_wave_word] = false
effect_letter_by_letter[dd_effect.mexican_wave_letter] = true
effect_letter_by_letter[dd_effect.mexican_wave_scale] = true
effect_letter_by_letter[dd_effect.mexican_wave_alpha] = true
effect_letter_by_letter[dd_effect.rainbow_short] = true
effect_letter_by_letter[dd_effect.rainbow_long] = true
effect_letter_by_letter[dd_effect.rainbow_animated_word] = false
effect_letter_by_letter[dd_effect.rainbow_animated_letter] = true
effect_letter_by_letter[dd_effect.sinewave_word_h]  = false
effect_letter_by_letter[dd_effect.sinewave_word_v] = false
effect_letter_by_letter[dd_effect.sinewave_word_scale] = false
effect_letter_by_letter[dd_effect.sinewave_letter_h] = true
effect_letter_by_letter[dd_effect.sinewave_letter_v] = true
effect_letter_by_letter[dd_effect.sinewave_letter_scale] = true
effect_letter_by_letter[dd_effect.sinewave_word_h_slow]  = false
effect_letter_by_letter[dd_effect.sinewave_word_v_slow] = false
effect_letter_by_letter[dd_effect.sinewave_word_scale_slow] = false
effect_letter_by_letter[dd_effect.sinewave_letter_h_slow] = true
effect_letter_by_letter[dd_effect.sinewave_letter_v_slow] = true
effect_letter_by_letter[dd_effect.sinewave_letter_scale_slow] = true
effect_letter_by_letter[dd_effect.rotate_smooth] = true
effect_letter_by_letter[dd_effect.rotate_letter_fixed] = true
effect_letter_by_letter[dd_effect.rotate_letter_shake] = true
effect_letter_by_letter[dd_effect.popping] = true
effect_letter_by_letter[dd_effect.beat] = true
effect_letter_by_letter[dd_effect.heart_beat_word] = false
effect_letter_by_letter[dd_effect.heart_beat_letter] = true
effect_letter_by_letter[dd_effect.heart_beat_alpha] = true
effect_letter_by_letter[dd_effect.flash] = false
effect_letter_by_letter[dd_effect.squeeze_squish] = true
effect_letter_by_letter[dd_effect.intro_alpha_slow] = true
effect_letter_by_letter[dd_effect.intro_alpha_fast] = true
effect_letter_by_letter[dd_effect.intro_top_with_alpha] = true
effect_letter_by_letter[dd_effect.intro_bottom_right] = true
effect_letter_by_letter[dd_effect.intro_big_to_normal] = true
effect_letter_by_letter[dd_effect.intro_small_to_normal] = true
effect_letter_by_letter[dd_effect.intro_fall_in] = true
effect_letter_by_letter[dd_effect.intro_slide_right] = true
effect_letter_by_letter[dd_effect.intro_black_to_grey] = true
effect_letter_by_letter[dd_effect.intro_white_to_grey] = true
effect_letter_by_letter[dd_effect.intro_red_to_grey] = true
effect_letter_by_letter[dd_effect.intro_wobble] = true
effect_letter_by_letter[dd_effect.intro_sine_v] = true
effect_letter_by_letter[dd_effect.intro_wind_in] = true
effect_letter_by_letter[dd_effect.intro_chromatic_aberration] = true
effect_letter_by_letter[dd_effect.intro_big_height_small_width] = true
effect_letter_by_letter[dd_effect.intro_big_width_small_height] = true
effect_letter_by_letter[dd_effect.block_1s] = false
effect_letter_by_letter[dd_effect.block_2s] = false
effect_letter_by_letter[dd_effect.block_3s] = false
effect_letter_by_letter[dd_effect.block_4s] = false
effect_letter_by_letter[dd_effect.intro_fadein_thendull_1s] = false
effect_letter_by_letter[dd_effect.intro_fadein_thendull_2s] = false
effect_letter_by_letter[dd_effect.intro_fadein_thendull_3s] = false
#endregion

#region All of the markup you can have 

style_markup = array_create(dd_style.size)
style_font = array_create(dd_style.size)
style_colour = array_create(dd_style.size)
style_effect = array_create(dd_style.size)
style_speed = array_create(dd_style.size)
style_markup_length = array_create(dd_style.size)

var this_style = dd_style.normal
style_markup[this_style] = "normal"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.none
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.blue
style_markup[this_style] = "blue"
style_font[this_style] = font_standard
style_colour[this_style] = c_blue
style_effect[this_style] = dd_effect.none
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.green
style_markup[this_style] = "green"
style_font[this_style] = font_standard
style_colour[this_style] = make_colour_rgb(17,147,39)
style_effect[this_style] = dd_effect.none
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.red
style_markup[this_style] = "red"
style_font[this_style] = font_standard
style_colour[this_style] = make_colour_rgb(201,28,0)
style_effect[this_style] = dd_effect.intro_fall_in
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.purple
style_markup[this_style] = "purple"
style_font[this_style] = font_standard
style_colour[this_style] = make_colour_rgb(142,55,141)
style_effect[this_style] = dd_effect.none
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.purplewave
style_markup[this_style] = "purplewave"
style_font[this_style] = font_standard
style_colour[this_style] = make_colour_rgb(142,55,141)
style_effect[this_style] = dd_effect.sinewave_letter_v
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.small
style_markup[this_style] = "small"
style_font[this_style] = font_small
style_colour[this_style] = c_white
style_effect[this_style] = dd_effect.none
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.shake
style_markup[this_style] = "shake"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.wobble_word
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.red_underline
style_markup[this_style] = "red_underline"
style_font[this_style] = font_standard
style_colour[this_style] = c_red
style_effect[this_style] = dd_effect.underline
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.underline
style_markup[this_style] = "underline"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.underline
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.green_strikethrough
style_markup[this_style] = "green_strikethrough"
style_font[this_style] = font_standard
style_colour[this_style] = c_green
style_effect[this_style] = dd_effect.strikethrough
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.quicktype
style_markup[this_style] = "quicktype"
style_font[this_style] = font_standard
style_colour[this_style] = c_white
style_effect[this_style] = dd_effect.none
style_speed[this_style] = 0

var this_style = dd_style.slowtype
style_markup[this_style] = "slowtype"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.none
style_speed[this_style] = 20

var this_style = dd_style.effect1
style_markup[this_style] = "effect1"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.sinewave_word_h
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect2
style_markup[this_style] = "effect2"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.sinewave_word_v
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect3
style_markup[this_style] = "effect3"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.sinewave_letter_v
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect4
style_markup[this_style] = "effect4"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.sinewave_letter_h
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect5
style_markup[this_style] = "effect5"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.rainbow_short
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect6
style_markup[this_style] = "effect6"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.rainbow_long
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect7
style_markup[this_style] = "effect7"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.wobble_letter
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect8
style_markup[this_style] = "effect8"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.rotate_smooth
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect9
style_markup[this_style] = "effect9"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.sinewave_word_scale
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect10
style_markup[this_style] = "effect10"
style_font[this_style] = font_standard
style_colour[this_style] = c_black
style_effect[this_style] = dd_effect.sinewave_letter_scale
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect11
style_markup[this_style] = "effect11"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.popping
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect12
style_markup[this_style] = "effect12"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.sinewave_word_scale_slow
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect13
style_markup[this_style] = "effect13"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.squeeze_squish
style_speed[this_style] = 0

var this_style = dd_style.effect14
style_markup[this_style] = "effect14"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.bounce_word
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect15
style_markup[this_style] = "effect15"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.bounce_letter
style_speed[this_style] = 10

var this_style = dd_style.effect16
style_markup[this_style] = "effect16"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.mexican_wave_word
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect17
style_markup[this_style] = "effect17"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.mexican_wave_letter
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect18
style_markup[this_style] = "effect18"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.mexican_wave_scale
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect19
style_markup[this_style] = "effect19"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.mexican_wave_alpha
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect20
style_markup[this_style] = "effect20"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.flash
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect21_a
style_markup[this_style] = "effect21_a"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.heart_beat_word
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect21_b
style_markup[this_style] = "effect21_b"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.heart_beat_letter
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect22
style_markup[this_style] = "effect22"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.flicker_alpha
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect23
style_markup[this_style] = "effect23"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.flicker_alpha_constant
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.shadow1
style_markup[this_style] = "shadow1"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.shadow1
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.shadow2
style_markup[this_style] = "shadow2"
style_font[this_style] = font_standard
style_colour[this_style] = c_lime
style_effect[this_style] = dd_effect.shadow2
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.stroke1
style_markup[this_style] = "stroke1"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.stroke1
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.stroke2
style_markup[this_style] = "stroke2"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.stroke2
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.intro1
style_markup[this_style] = "intro1"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.intro_alpha_slow
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.intro2
style_markup[this_style] = "intro2"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.intro_alpha_fast
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.intro3
style_markup[this_style] = "intro3"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.intro_top_with_alpha
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.intro4
style_markup[this_style] = "intro4"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.intro_bottom_right
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.intro5
style_markup[this_style] = "intro5"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.intro_big_to_normal
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.intro6
style_markup[this_style] = "intro6"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.intro_small_to_normal
style_speed[this_style] = 6

var this_style = dd_style.intro7
style_markup[this_style] = "intro7"
style_font[this_style] = font_standard
style_colour[this_style] = make_colour_rgb(17,147,39)
style_effect[this_style] = dd_effect.intro_fall_in
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.intro8
style_markup[this_style] = "intro8"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.intro_black_to_grey
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.intro9
style_markup[this_style] = "intro9"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.intro_white_to_grey
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.intro10
style_markup[this_style] = "intro10"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.intro_red_to_grey
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect24
style_markup[this_style] = "effect24"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.rainbow_animated_letter
style_speed[this_style] = 4

var this_style = dd_style.effect25
style_markup[this_style] = "effect25"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.rainbow_animated_word
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.intro11
style_markup[this_style] = "intro11"
style_font[this_style] = font_standard
style_colour[this_style] = make_colour_rgb(142,55,141)
style_effect[this_style] = dd_effect.intro_slide_right
style_speed[this_style] = 3

var this_style = dd_style.intro12
style_markup[this_style] = "intro12"
style_font[this_style] = font_standard
style_colour[this_style] = make_colour_rgb(201,28,0)
style_effect[this_style] = dd_effect.intro_wobble
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.intro13
style_markup[this_style] = "intro13"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.intro_sine_v
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.intro14
style_markup[this_style] = "intro14"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.intro_wind_in
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect26
style_markup[this_style] = "effect26"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.stroke_animated
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.effect27
style_markup[this_style] = "effect27"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.stroke_animated_black
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.whiteshadowquicktype
style_markup[this_style] = "whiteshadowquicktype"
style_font[this_style] = font_bold
style_colour[this_style] = c_white
style_effect[this_style] = dd_effect.shadow1
style_speed[this_style] = 0

var this_style = dd_style.whiteshadowquicktype
style_markup[this_style] = "whiteshadowquicktype"
style_font[this_style] = font_bold
style_colour[this_style] = c_white
style_effect[this_style] = dd_effect.shadow1
style_speed[this_style] = 0

var this_style = dd_style.fadyblock_1
style_markup[this_style] = "fadyblock_1"
style_font[this_style] = font_standard
style_colour[this_style] = c_red//make_colour_rgb(225,220,177)
style_effect[this_style] = dd_effect.intro_fadein_thendull_2s
style_speed[this_style] = 0

var this_style = dd_style.fadyblock_2
style_markup[this_style] = "fadyblock_2"
style_font[this_style] = font_standard
style_colour[this_style] = make_colour_rgb(33,33,33)
style_effect[this_style] = dd_effect.intro_fadein_thendull_1s
style_speed[this_style] = 0

var this_style = dd_style.fadyblock_3
style_markup[this_style] = "fadyblock_3"
style_font[this_style] = font_standard
style_colour[this_style] = make_colour_rgb(33,33,33)
style_effect[this_style] = dd_effect.intro_fadein_thendull_2s
style_speed[this_style] = 0

var this_style = dd_style.fadyblock_4
style_markup[this_style] = "fadyblock_4"
style_font[this_style] = font_standard
style_colour[this_style] = make_colour_rgb(33,33,33)
style_effect[this_style] = dd_effect.intro_fadein_thendull_3s
style_speed[this_style] = 0

var this_style = dd_style.neweffects1
style_markup[this_style] = "neweffects1"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.intro_big_width_small_height
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.neweffects2
style_markup[this_style] = "neweffects2"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.intro_chromatic_aberration
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.neweffects3
style_markup[this_style] = "neweffects3"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.heart_beat_alpha
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.neweffects4
style_markup[this_style] = "neweffects4"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.heart_beat_letter 
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.neweffects5
style_markup[this_style] = "neweffects5"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.heart_beat_word 
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.neweffects6
style_markup[this_style] = "neweffects6"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.beat 
style_speed[this_style] = frames_per_character_standard

var this_style = dd_style.neweffects7
style_markup[this_style] = "neweffects7"
style_font[this_style] = font_standard
style_colour[this_style] = c_dkgray
style_effect[this_style] = dd_effect.beatfast 
style_speed[this_style] = frames_per_character_standard

// preprocess the styles so you know the length of the markup 
for (var i = 0; i < dd_style.size; ++i) {
	style_markup[i] += markup_character_end
	style_markup_length[i] = string_length(style_markup[i])
}

#region inlineables (other things you can put in markup sounds/icons/scripts/screenshake)
	
	// SOUNDS INLINABLES
	enum dd_inlineable_sound {
		sound_example1,
		sound_example2,
	
		size
	}

	inlineable_sound_markup = array_create(dd_inlineable_sound.size)
	inlineable_sound_file = array_create(dd_inlineable_sound.size)
	inlineable_sound_markup_length = array_create(dd_inlineable_sound.size)

	var this_inlineable = dd_inlineable_sound.sound_example1
	inlineable_sound_markup[this_inlineable] = "sound_1"
	inlineable_sound_file[this_inlineable] = snd_test1

	var this_inlineable = dd_inlineable_sound.sound_example2
	inlineable_sound_markup[this_inlineable] = "sound_2"
	inlineable_sound_file[this_inlineable] = snd_test2

	// preprocess the sounds so you know the length of the markup 
	for (var i = 0; i < dd_inlineable_sound.size; ++i) {
		inlineable_sound_markup[i] += markup_character_end
		inlineable_sound_markup_length[i] = string_length(inlineable_sound_markup[i])
	}


	// SCRIPT INLINABLES
	enum dd_inlineable_script {
		script_example1,
		script_example2,
		script_example3,
	
		size
	}
	
	inlineable_script_markup = array_create(dd_inlineable_script.size)
	inlineable_script = array_create(dd_inlineable_script.size)
	inlineable_script_markup_length = array_create(dd_inlineable_script.size)

	var this_inlineable = dd_inlineable_script.script_example1
	inlineable_script_markup[this_inlineable] = "script_1"
	inlineable_script[this_inlineable] = scr_test1

	var this_inlineable = dd_inlineable_script.script_example2
	inlineable_script_markup[this_inlineable] = "script_2"
	inlineable_script[this_inlineable] = scr_test2

	var this_inlineable = dd_inlineable_script.script_example3
	inlineable_script_markup[this_inlineable] = "script_3"
	inlineable_script[this_inlineable] = scr_test3

	// preprocess the scripts so you know the length of the markup 
	for (var i = 0; i < dd_inlineable_script.size; ++i) {
		inlineable_script_markup[i] += markup_character_end
		inlineable_script_markup_length[i] = string_length(inlineable_script_markup[i])
	}


	// SCREENSHAKE INLINABLES
	enum dd_inlineable_screenshake {
		screenshake_example1,
		screenshake_example2,
	
		size
	}
	
	inlineable_screenshake_markup = array_create(dd_inlineable_screenshake.size)
	inlineable_screenshake_data = array_create(dd_inlineable_screenshake.size)
	inlineable_screenshake_markup_length = array_create(dd_inlineable_screenshake.size)

	var this_inlineable = dd_inlineable_screenshake.screenshake_example1
	inlineable_screenshake_markup[this_inlineable] = "screenshake_1"
	inlineable_screenshake_data[this_inlineable] = 100

	var this_inlineable = dd_inlineable_screenshake.screenshake_example2
	inlineable_screenshake_markup[this_inlineable] = "screenshake_2"
	inlineable_screenshake_data[this_inlineable] = 500


	// preprocess the screenshakes so you know the length of the markup 
	for (var i = 0; i < dd_inlineable_screenshake.size; ++i) {
		inlineable_screenshake_markup[i] += markup_character_end
		inlineable_screenshake_markup_length[i] = string_length(inlineable_screenshake_markup[i])
	}


	// IMAGE INLINABLES
	enum dd_inlineable_image {
		image_example1,
		image_example2,
		image_example3,
		image_example4,
	
		size
	}
	
	inlineable_image_markup = array_create(dd_inlineable_image.size)
	inlineable_image_sprite = array_create(dd_inlineable_image.size)
	inlineable_image_width = array_create(dd_inlineable_image.size)
	inlineable_image_markup_length = array_create(dd_inlineable_image.size)

	var this_inlineable = dd_inlineable_image.image_example1
	inlineable_image_markup[this_inlineable] = "image_1"
	inlineable_image_sprite[this_inlineable] = spr_test1
	inlineable_image_width[this_inlineable] = 32

	var this_inlineable = dd_inlineable_image.image_example2
	inlineable_image_markup[this_inlineable] = "image_2"
	inlineable_image_sprite[this_inlineable] = spr_test2
	inlineable_image_width[this_inlineable] = 26

	var this_inlineable = dd_inlineable_image.image_example3
	inlineable_image_markup[this_inlineable] = "image_3"
	inlineable_image_sprite[this_inlineable] = spr_test3
	inlineable_image_width[this_inlineable] = 32

	var this_inlineable = dd_inlineable_image.image_example4
	inlineable_image_markup[this_inlineable] = "image_4"
	inlineable_image_sprite[this_inlineable] = spr_test4
	inlineable_image_width[this_inlineable] = 22


	// preprocess the images so you know the length of the markup 
	for (var i = 0; i < dd_inlineable_image.size; ++i) {
		inlineable_image_markup[i] += markup_character_end
		inlineable_image_markup_length[i] = string_length(inlineable_image_markup[i])
	}

	// CODE INLINABLES
	enum dd_inlineable_code {
		linebreak,
		delay_1s,
		delay_2s,
		delay_3s,
		delay_4s,
	
		size
	}

	inlineable_code_markup = array_create(dd_inlineable_code.size)
	inlineable_code_markup_length = array_create(dd_inlineable_code.size)

	var this_inlineable = dd_inlineable_code.linebreak
	inlineable_code_markup[this_inlineable] = "linebreak"

	var this_inlineable = dd_inlineable_code.delay_1s
	inlineable_code_markup[this_inlineable] = "delay_1s"

	var this_inlineable = dd_inlineable_code.delay_2s
	inlineable_code_markup[this_inlineable] = "delay_2s"

	var this_inlineable = dd_inlineable_code.delay_3s
	inlineable_code_markup[this_inlineable] = "delay_3s"

	var this_inlineable = dd_inlineable_code.delay_4s
	inlineable_code_markup[this_inlineable] = "delay_4s"


	// preprocess the code inlineable so you know the length of the markup 
	for (var i = 0; i < dd_inlineable_code.size; ++i) {
		inlineable_code_markup[i] += markup_character_end
		inlineable_code_markup_length[i] = string_length(inlineable_code_markup[i])
	}


#endregion

#endregion

enum dd_action_list {
	nothing = -1,
	close = -2,
	close_no_animation = -3,
	display_text = -4,
	frame0 = -5, // this just skips the block/character, perfect if you are using blocks and the player just wants to skip through them. 
}


enum dd_id {
	test1,
	test2,
	test3,
	test4,
	test5,
	test6,
	test7,
	test8, 
	convo_1, 
	convo_2, 
	story_test1, 
	newstyles1,
	
	size
}

dd_text = array_create(dd_id.size)
dd_image_left = array_create(dd_id.size)
dd_image_right = array_create(dd_id.size)
dd_sound = array_create(dd_id.size)
dd_speaker_name = array_create(dd_id.size)
dd_speaker_name_style = array_create(dd_id.size)
dd_align = array_create(dd_id.size)
dd_affirmative_pressed = array_create(dd_id.size)
dd_negative_pressed = array_create(dd_id.size)
dd_anything_pressed = array_create(dd_id.size)
dd_affirmative_pressed_during_talking = array_create(dd_id.size)
dd_negative_pressed_during_talking = array_create(dd_id.size)
dd_anything_pressed_during_talking = array_create(dd_id.size)
dd_responce_text = array_create(dd_id.size)
dd_responce_action = array_create(dd_id.size)
dd_responce_style = array_create(dd_id.size)
dd_responce_style_selected = array_create(dd_id.size)
dd_responce_count = array_create(dd_id.size)


var this_dialogue = dd_id.test1
dd_text[this_dialogue] = "Normal. {sound_1}{blue}Blue {effect27}effect 27 {effect26}effect 26 {intro14}intro 14 {intro13}intro 13 qwerty {intro12}intro 12 qwerty {intro11}intro 11 qwerty {effect25}effect25 {effect24}effect24 {intro10}intro 10 qwerty {intro9}intro 9 qwerty{sound_2} {intro8}intro 8 qwerty {intro7}intro 7 qwerty {intro6}intro 6 qwerty {intro5}intro 5 qwerty {intro4}intro 4 qwerty {intro3}intro 3 qwerty {intro2}intro 2 qwerty {intro1}intro 1 qwerty {effect23}effect23 {effect22}effect22 {effect21}effect21 {effect20}effect20 {effect19}effect19 {effect18}effect18 {effect17}effect17 {effect16}effect16 {effect15}effect15 {effect14}effect14 {effect13}effect13 {stroke1}stroke1 {stroke2}stroke2 {shadow1}shadow1 {shadow2}shadow2 {effect12}effect12 {effect11}effect11 {effect10}effect10 {effect9}effect9 {effect8}effect8 {effect7}effect7 {effect6}effect6 effect6 effect6 effect6 {effect5}effect5 effect5 effect5 effect5 {effect4}effect4 {effect3}effect3 {effect2}effect2 {effect1}effect1 {normal}mmm,,,mmm,,, David is a really good boy {quicktype}mmm,,,mmm,,, {red_underline}red_underline {normal}normal {green_strikethrough}green_strikethrough {red_underline}red_underline {blue}blue {normal}normal {small}small {shake}shake {normal},,!!,,!!,,!!  ,,  ,,  ,,  ,,  ,,{quicktype},,!!,,!!,,!!  ,,  ,,  ,,  ,,  ,,{normal}normal"
dd_image_left[this_dialogue] = spr_dialogue_character1 // -1 none, spr could be a greyed out version to show who is being on both sides 
dd_image_right[this_dialogue] = spr_dialogue_character1 // this gets flipped horizontally so all images should look to the right
dd_sound[this_dialogue] = -1
dd_speaker_name[this_dialogue] = "Dave"
dd_speaker_name_style[this_dialogue] = dd_style.normal
dd_align[this_dialogue] = fa_left
dd_affirmative_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_affirmative_pressed_during_talking[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed_during_talking[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed_during_talking[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
var r = 0
dd_responce_text[this_dialogue][r] = "Yes"
dd_responce_action[this_dialogue][r] = dd_id.test8 // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_text[this_dialogue][r] = "No"
dd_responce_action[this_dialogue][r] = dd_action_list.close // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_text[this_dialogue][r] = "Quit"
dd_responce_action[this_dialogue][r] = dd_action_list.close // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_count[this_dialogue] = r


var this_dialogue = dd_id.test2
dd_text[this_dialogue] = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
dd_image_left[this_dialogue] = spr_dialogue_character1 // -1 none, spr could be a greyed out version to show who is being on both sides 
dd_image_right[this_dialogue] = spr_dialogue_character1 // this gets flipped horizontally so all images should look to the rightdd_sound[this_dialogue] = -1
dd_speaker_name[this_dialogue] = "Dave"
dd_speaker_name_style[this_dialogue] = dd_style.normal
dd_align[this_dialogue] = fa_right
dd_affirmative_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_affirmative_pressed_during_talking[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed_during_talking[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed_during_talking[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
var r = 0
dd_responce_text[this_dialogue][r] = "Yes"
dd_responce_action[this_dialogue][r] = dd_id.test8 // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_text[this_dialogue][r] = "No"
dd_responce_action[this_dialogue][r] = dd_action_list.close // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_text[this_dialogue][r] = "Quit"
dd_responce_action[this_dialogue][r] = dd_action_list.close // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_count[this_dialogue] = r



var this_dialogue = dd_id.test3
dd_text[this_dialogue] = "Lorem {image_1}ipsum {screenshake_1}dolor {linebreak}sit am>>{image_2}<<et, {sound_1}consectetur adipiscing {script_1}elit, sed do eiusmod tempor incididunt ut labor{script_2}e et dolore {linebreak}magna aliqua. >>>>{script_3}<<<<Ut enim ad minim veniam, quis {linebreak}nostrud exercitation ullamco laboris nisi ut aliquip{sound_2} {linebreak}ex ea commodo consdd{image_1}ddequat. Duis aute irure doldd{image_3}ddor in reprehenderit in voluptate velit esse cillu{screenshake_2}m dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
dd_image_left[this_dialogue] = spr_dialogue_character1 // -1 none, spr could be a greyed out version to show who is being on both sides 
dd_image_right[this_dialogue] = spr_dialogue_character1 // this gets flipped horizontally so all images should look to the rightdd_sound[this_dialogue] = -1
dd_speaker_name[this_dialogue] = "Dave"
dd_speaker_name_style[this_dialogue] = dd_style.normal
dd_align[this_dialogue] = fa_left
dd_affirmative_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_affirmative_pressed_during_talking[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed_during_talking[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed_during_talking[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
var r = 0
dd_responce_text[this_dialogue][r] = "Yes"
dd_responce_action[this_dialogue][r] = dd_id.test8 // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_text[this_dialogue][r] = "No"
dd_responce_action[this_dialogue][r] = dd_action_list.close // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_text[this_dialogue][r] = "Quit"
dd_responce_action[this_dialogue][r] = dd_action_list.close // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_count[this_dialogue] = r



var this_dialogue = dd_id.test4
dd_text[this_dialogue] = "Dave's new {green}dialogue {purple}system{normal}. Text can be {effect9}animated{normal} like {effect1}waving back {linebreak}and forth{normal}. You can {effect17}make wripples go down the text {normal} or {shake}shake{normal} if is {effect10}scary{normal}. I can {effect24}change the colour{normal} and make it {effect23}flicker{normal} or even add a {effect26}glow{normal}. {linebreak}I've even made {effect13}30 {effect4}weird {effect11}effects {effect8}that can be used{normal}."
dd_image_left[this_dialogue] = spr_dialogue_character1 // -1 none, spr could be a greyed out version to show who is being on both sides 
dd_image_right[this_dialogue] = spr_dialogue_character1 // this gets flipped horizontally so all images should look to the rightdd_sound[this_dialogue] = -1
dd_speaker_name[this_dialogue] = "Dave"
dd_speaker_name_style[this_dialogue] = dd_style.normal
dd_align[this_dialogue] = fa_left
dd_affirmative_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_affirmative_pressed_during_talking[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed_during_talking[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed_during_talking[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
var r = 0
dd_responce_text[this_dialogue][r] = "Yes"
dd_responce_action[this_dialogue][r] = dd_id.test8 // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_text[this_dialogue][r] = "No"
dd_responce_action[this_dialogue][r] = dd_action_list.close // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_text[this_dialogue][r] = "Quit"
dd_responce_action[this_dialogue][r] = dd_action_list.close // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_count[this_dialogue] = r



var this_dialogue = dd_id.test5
dd_text[this_dialogue] = "{intro13}Text can have different animations when they come on. {linebreak}{intro7}This text falls down one letter at a time. {linebreak}{intro12}This one shakes until it is still. {linebreak}{intro11}Here is a subtle slide in and a change of text typing speed.{linebreak}{intro6}Simple scale but with slow typing speed. {linebreak}{intro10}Colour changing.... weeee...."
dd_image_left[this_dialogue] = spr_dialogue_character1 // -1 none, spr could be a greyed out version to show who is being on both sides 
dd_image_right[this_dialogue] = spr_dialogue_character1 // this gets flipped horizontally so all images should look to the rightdd_sound[this_dialogue] = -1
dd_speaker_name[this_dialogue] = "Dave"
dd_speaker_name_style[this_dialogue] = dd_style.normal
dd_align[this_dialogue] = fa_left
dd_affirmative_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_affirmative_pressed_during_talking[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed_during_talking[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed_during_talking[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
var r = 0
dd_responce_text[this_dialogue][r] = "Yes"
dd_responce_action[this_dialogue][r] = dd_id.test8 // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_text[this_dialogue][r] = "No"
dd_responce_action[this_dialogue][r] = dd_action_list.close // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_text[this_dialogue][r] = "Quit"
dd_responce_action[this_dialogue][r] = dd_action_list.close // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_count[this_dialogue] = r


var this_dialogue = dd_id.test6
dd_text[this_dialogue] = "I've got inline {purple}images{normal} {image_1}working on my {green}dialogue system{normal}. Its cool to put icons{image_2} next{image_3}to what you need{image_4}.  {linebreak}You can also do {purple}screenshake{normal},  play {purple}sounds{normal},  {purplewave}animate{normal} text,  run {purple}functions{normal},  {linebreak}have {purple}dialogue trees{normal}. {linebreak}{whiteshadowquicktype} >>> Wow! Sounds great, tell me more{linebreak} >>> I think {green}Dialogue{whiteshadowquicktype} in games is stupid {normal} "
dd_image_left[this_dialogue] = spr_dialogue_character2 // -1 none, spr could be a greyed out version to show who is being on both sides 
dd_image_right[this_dialogue] = spr_dialogue_character6 // this gets flipped horizontally so all images should look to the rightdd_sound[this_dialogue] = -1
dd_speaker_name[this_dialogue] = "Dave"
dd_speaker_name_style[this_dialogue] = dd_style.normal
dd_align[this_dialogue] = fa_left
dd_affirmative_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_affirmative_pressed_during_talking[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed_during_talking[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed_during_talking[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
var r = 0
dd_responce_text[this_dialogue][r] = "Yes"
dd_responce_action[this_dialogue][r] = dd_id.test8 // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_text[this_dialogue][r] = "No"
dd_responce_action[this_dialogue][r] = dd_action_list.close // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_text[this_dialogue][r] = "Quit"
dd_responce_action[this_dialogue][r] = dd_action_list.close // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_count[this_dialogue] = r



var this_dialogue = dd_id.test7
dd_text[this_dialogue] = "{purple}Do {normal}you {effect5}like {intro10}socks{normal}?"
dd_image_left[this_dialogue] = spr_dialogue_character2 // -1 none, spr could be a greyed out version to show who is being on both sides 
dd_image_right[this_dialogue] = spr_dialogue_character5 // this gets flipped horizontally so all images should look to the rightdd_sound[this_dialogue] = -1
dd_speaker_name[this_dialogue] = "Dave"
dd_speaker_name_style[this_dialogue] = dd_style.normal
dd_align[this_dialogue] = fa_left
dd_affirmative_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_affirmative_pressed_during_talking[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed_during_talking[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed_during_talking[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
var r = 0
dd_responce_text[this_dialogue][r] = "Yes"
dd_responce_action[this_dialogue][r] = dd_id.test8 // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_text[this_dialogue][r] = "No"
dd_responce_action[this_dialogue][r] = dd_action_list.close // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_text[this_dialogue][r] = "Quit"
dd_responce_action[this_dialogue][r] = dd_action_list.close // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_count[this_dialogue] = r


var this_dialogue = dd_id.test8
dd_text[this_dialogue] = "{quicktype}..... {effect8}Reply {intro14}test{normal}?"
dd_image_left[this_dialogue] = spr_dialogue_character1 // -1 none, spr could be a greyed out version to show who is being on both sides 
dd_image_right[this_dialogue] = -1 // this gets flipped horizontally so all images should look to the rightdd_sound[this_dialogue] = -1
dd_speaker_name[this_dialogue] = "Dave"
dd_speaker_name_style[this_dialogue] = dd_style.normal
dd_align[this_dialogue] = fa_left
dd_affirmative_pressed[this_dialogue] = dd_action_list.display_text // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed[this_dialogue] = dd_action_list.close_no_animation // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_affirmative_pressed_during_talking[this_dialogue] = dd_action_list.display_text // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed_during_talking[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed_during_talking[this_dialogue] = dd_action_list.nothing // Accepts: dd_action_list, dd_id, script id
var r = 0
dd_responce_text[this_dialogue][r] = "Yes"
dd_responce_action[this_dialogue][r] = dd_id.test8 // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_text[this_dialogue][r] = "No"
dd_responce_action[this_dialogue][r] = dd_action_list.close // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_text[this_dialogue][r] = "Quit"
dd_responce_action[this_dialogue][r] = dd_action_list.close // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_count[this_dialogue] = r

var this_dialogue = dd_id.convo_1
dd_text[this_dialogue] = "Talking back and forth between two people"
dd_image_left[this_dialogue] = spr_dialogue_character3 // -1 none, spr could be a greyed out version to show who is being on both sides 
dd_image_right[this_dialogue] = spr_dialogue_character6 // this gets flipped horizontally so all images should look to the rightdd_sound[this_dialogue] = -1
dd_speaker_name[this_dialogue] = "Dave"
dd_speaker_name_style[this_dialogue] = dd_style.normal
dd_align[this_dialogue] = fa_left
dd_affirmative_pressed[this_dialogue] = dd_action_list.nothing // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed[this_dialogue] = dd_action_list.nothing // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed[this_dialogue] = dd_action_list.nothing // Accepts: dd_action_list, dd_id, script id
dd_affirmative_pressed_during_talking[this_dialogue] = dd_action_list.display_text // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed_during_talking[this_dialogue] = dd_action_list.display_text // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed_during_talking[this_dialogue] = dd_action_list.display_text // Accepts: dd_action_list, dd_id, script id
var r = 0
dd_responce_text[this_dialogue][r] = "Talk to other person"
dd_responce_action[this_dialogue][r] = dd_id.convo_2 // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_text[this_dialogue][r] = "Close"
dd_responce_action[this_dialogue][r] = dd_action_list.close // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_count[this_dialogue] = r


var this_dialogue = dd_id.convo_2
dd_text[this_dialogue] = "Talking to second person "
dd_image_left[this_dialogue] = spr_dialogue_character7 // -1 none, spr could be a greyed out version to show who is being on both sides 
dd_image_right[this_dialogue] = spr_dialogue_character4 // this gets flipped horizontally so all images should look to the rightdd_sound[this_dialogue] = -1
dd_speaker_name[this_dialogue] = "Not Dave"
dd_speaker_name_style[this_dialogue] = dd_style.normal
dd_align[this_dialogue] = fa_right
dd_affirmative_pressed[this_dialogue] = dd_action_list.nothing // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed[this_dialogue] = dd_action_list.nothing // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed[this_dialogue] = dd_action_list.nothing // Accepts: dd_action_list, dd_id, script id
dd_affirmative_pressed_during_talking[this_dialogue] = dd_action_list.display_text // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed_during_talking[this_dialogue] = dd_action_list.display_text // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed_during_talking[this_dialogue] = dd_action_list.display_text // Accepts: dd_action_list, dd_id, script id
var r = 0
dd_responce_text[this_dialogue][r] = "Talk to other person"
dd_responce_action[this_dialogue][r] = dd_id.convo_1 // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_text[this_dialogue][r] = "Close"
dd_responce_action[this_dialogue][r] = dd_action_list.close // could be a script/dialogue id/close dd
dd_responce_style[this_dialogue][r] = dd_style.normal
dd_responce_style_selected[this_dialogue][r] = dd_style.blue
r++
dd_responce_count[this_dialogue] = r



var this_dialogue = dd_id.story_test1
dd_text[this_dialogue] = "{fadyblock_1}It arrived without warning. {fadyblock_2}But yet no one was scared. {linebreak}{fadyblock_4}The town had been preparing but no one expected it to really happen. {linebreak}{fadyblock_3}This wouldn't be the last time."
dd_image_left[this_dialogue] = spr_dialogue_character1 // -1 none, spr could be a greyed out version to show who is being on both sides 
dd_image_right[this_dialogue] = spr_dialogue_character1 // this gets flipped horizontally so all images should look to the right
dd_sound[this_dialogue] = -1
dd_speaker_name[this_dialogue] = "Dave"
dd_speaker_name_style[this_dialogue] = dd_style.normal
dd_align[this_dialogue] = fa_left
dd_affirmative_pressed[this_dialogue] = dd_action_list.nothing // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed[this_dialogue] = dd_action_list.nothing // Accepts: dd_action_list, dd_id, script id
dd_affirmative_pressed_during_talking[this_dialogue] = dd_action_list.frame0 // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed_during_talking[this_dialogue] = dd_action_list.display_text // Accepts: dd_action_list, dd_id, script idf
dd_anything_pressed_during_talking[this_dialogue] = dd_action_list.frame0 // Accepts: dd_action_list, dd_id, script id
var r = 0
dd_responce_count[this_dialogue] = r


var this_dialogue = dd_id.newstyles1
dd_text[this_dialogue] = "{neweffects1}It arrived without warning. {neweffects2}But yet no one was scared. {linebreak}{neweffects3}The town had been preparing but no one {neweffects4}expected it to really happen. {linebreak}{neweffects5}This wouldn't be the last time.{linebreak}{neweffects6}Normal beat.{normal}dave normal text after. {linebreak}{neweffects7}Beat fast.{normal}dave normal text after.{linebreak}{effect16}style16 style16 style16 {effect17}style17 style17 style17 {effect18}style18 style18 style18 {effect19}style19 style19 style19"
dd_image_left[this_dialogue] = spr_dialogue_character1 // -1 none, spr could be a greyed out version to show who is being on both sides 
dd_image_right[this_dialogue] = spr_dialogue_character1 // this gets flipped horizontally so all images should look to the right
dd_sound[this_dialogue] = -1
dd_speaker_name[this_dialogue] = "Dave"
dd_speaker_name_style[this_dialogue] = dd_style.normal
dd_align[this_dialogue] = fa_left
dd_affirmative_pressed[this_dialogue] = dd_action_list.nothing // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed[this_dialogue] = dd_action_list.close // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed[this_dialogue] = dd_action_list.nothing // Accepts: dd_action_list, dd_id, script id
dd_affirmative_pressed_during_talking[this_dialogue] = dd_action_list.frame0 // Accepts: dd_action_list, dd_id, script id
dd_negative_pressed_during_talking[this_dialogue] = dd_action_list.display_text // Accepts: dd_action_list, dd_id, script id
dd_anything_pressed_during_talking[this_dialogue] = dd_action_list.frame0 // Accepts: dd_action_list, dd_id, script id
var r = 0
dd_responce_count[this_dialogue] = r


#region rainbow colour palette55
var i = 0
rainbow_colour_palette_short[i++] = $0000ff
rainbow_colour_palette_short[i++] = $00ffff
rainbow_colour_palette_short[i++] = $00ff00
rainbow_colour_palette_short[i++] = $ffff00
rainbow_colour_palette_short[i++] = $ff0000
rainbow_colour_palette_short[i++] = $ff00ff
var i = 0
rainbow_colour_palette_long[i++] = $0000ff
rainbow_colour_palette_long[i++] = $0055ff
rainbow_colour_palette_long[i++] = $00aaff
rainbow_colour_palette_long[i++] = $00ffff
rainbow_colour_palette_long[i++] = $00ffaa
rainbow_colour_palette_long[i++] = $00ff55
rainbow_colour_palette_long[i++] = $00ff00
rainbow_colour_palette_long[i++] = $55ff00
rainbow_colour_palette_long[i++] = $aaff00
rainbow_colour_palette_long[i++] = $ffff00
rainbow_colour_palette_long[i++] = $ffaa00
rainbow_colour_palette_long[i++] = $ff5500
rainbow_colour_palette_long[i++] = $ff0000
rainbow_colour_palette_long[i++] = $ff0055
rainbow_colour_palette_long[i++] = $ff00aa
rainbow_colour_palette_long[i++] = $ff00ff
rainbow_colour_palette_long[i++] = $aa00ff
rainbow_colour_palette_long[i++] = $5500ff
var i = 0
black_to_grey_palette[i++] = $000000
black_to_grey_palette[i++] = $080808
black_to_grey_palette[i++] = $0F0F0F
black_to_grey_palette[i++] = $171717
black_to_grey_palette[i++] = $1F1F1F
black_to_grey_palette[i++] = $272727
black_to_grey_palette[i++] = $2E2E2E
black_to_grey_palette[i++] = $363636
black_to_grey_palette[i++] = $3E3E3E
black_to_grey_palette[i++] = $464646
black_to_grey_palette[i++] = $4D4D4D
black_to_grey_palette[i++] = $555555
var i = 0
white_to_grey_palette[i++] = $FFFFFF
white_to_grey_palette[i++] = $F0F0F0
white_to_grey_palette[i++] = $E0E0E0
white_to_grey_palette[i++] = $D1D1D1
white_to_grey_palette[i++] = $C1C1C1
white_to_grey_palette[i++] = $B2B2B2
white_to_grey_palette[i++] = $A2A2A2
white_to_grey_palette[i++] = $939393
white_to_grey_palette[i++] = $838383
white_to_grey_palette[i++] = $747474
white_to_grey_palette[i++] = $646464
white_to_grey_palette[i++] = $555555
var i = 0
red_to_grey_palette[i++] = $0000cc
red_to_grey_palette[i++] = $0808c1
red_to_grey_palette[i++] = $0f0fb6
red_to_grey_palette[i++] = $1717AC
red_to_grey_palette[i++] = $1F1FA1
red_to_grey_palette[i++] = $272796
red_to_grey_palette[i++] = $2E2E8B
red_to_grey_palette[i++] = $363680
red_to_grey_palette[i++] = $3E3E75
red_to_grey_palette[i++] = $46466B
red_to_grey_palette[i++] = $4D4D60
red_to_grey_palette[i++] = $555555

#endregion