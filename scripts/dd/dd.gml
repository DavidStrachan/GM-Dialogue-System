

function dd_display(dd_id) {
	with (obj_dd) {
		dd_reset()
	
		dd_to_display = dd_id
		display = 1 // 0=dont display, 1=animate in, 2=display, 3=animate out  
		animate_in_frame = 0
		data_maintext_style[0] = dd_style.normal
		data_maintext_effect[0] = -1
		data_maintext_image[0] = -1

	}
}

function dd_reset() {
	with (obj_dd) {
		// reset all the information to display a new dialogue
		dd_to_display = -1 // what dialogue id should we display 
		display = 0 // 0=dont display, 1=animate in, 2=display, 3=animate out
		type_out_complete = false // when all the text has been animated in 
		skip_typeout = false // dont individually type out every letter  
	
		data_maintext_text = [""] // these are the strings we want to draw 
		data_maintext_style = [-1] // this is the style id for each string we want to draw 
		data_maintext_effect = [-1] // this is the style id for each string we want to draw 
		data_maintext_image = [-1] // this is the effect id for each string we want to draw 
		data_maintext_x = [0,0] // where to draw this
		data_maintext_y = [0,0]
		data_maintext_line = [0] // what line is this block on

		running_x = 0 // as you are adding characters also increase this number
		running_x_for_line = [0] // same as running_x but resets when going to a new line 
		running_y = 0
		line_count = 0 
		character_along = 1
		animate_in_frame = 0
		frames_per_character_temp = frames_per_character_standard
		block_number = 0
		style_last = dd_style.normal
		style_current = dd_style.normal
		effects_data = 0 // any block of text can store data here about how it should be drawn, it will be reset when the dialogue is closed
		effects_data[0] = 0
		selected_reply = -1
	}
}

function dd_close() {
	// animate out the dialogue box
	with (obj_dd) {
		display = 3 // 0=dont display, 1=animate in, 2=display, 3=animate out  
		animate_out_frame = 0
	}
}

function dd_take_action(dd_action) {

	if (dd_action < 0) { // one of the dd_action_list
		switch (dd_action) {
		    case dd_action_list.close:
		        dd_close()	
		    break;
		    case dd_action_list.close_no_animation:
				// animate out the dialogue box
				with (obj_dd) {
					display = 0 // 0=dont display, 1=animate in, 2=display, 3=animate out  
					animate_out_frame = 0
				}
		    break;
		    case dd_action_list.display_text:
		        skip_typeout = true
				animate_in_frame = animate_in_frames
		    break;
		    case dd_action_list.frame0:
		        frame = 0
		    break;
		}	
	} else if (dd_action < 10000) { // display dialogue 
		dd_display(dd_action)
		display = 2 // 0=dont display, 1=animate in, 2=display, 3=animate out  
		animate_in_frame = animate_in_frames
	} else if (script_exists(dd_action)) {
		script_execute(dd_action)
	}
}

function dd_detect_input(dd_affirmative,dd_negative,dd_anything) {

	#region keyboard input
		var key_triggered = false
		var input_count = array_length(keyboard_affirmative)
		for (var dd_i = 0; dd_i < input_count; ++dd_i) {
			if (keyboard_check_pressed(keyboard_affirmative[dd_i])) {
				dd_take_action(dd_affirmative)
				key_triggered = true
			}
		}
		var input_count = array_length(keyboard_negative)
		for (var dd_i = 0; dd_i < input_count; ++dd_i) {
			if (keyboard_check_pressed(keyboard_negative[dd_i])) {
				dd_take_action(dd_negative)
				key_triggered = true
			}
		}
		if (key_triggered = false) { // any other button 
			if (keyboard_check_pressed(vk_anykey)) {
				dd_take_action(dd_anything)
			}
		}
	#endregion
	#region gamepad input
			
		var gp_num = gamepad_get_device_count();
								
		for (var gp = 0; gp < gp_num; gp++;) {
			if (gamepad_is_connected(gp)) {
			
				var key_triggered = false
				var input_count = array_length(gamepad_affirmative)
				for (var dd_i = 0; dd_i < input_count; ++dd_i) {
					if (gamepad_button_check(gp,gamepad_affirmative[dd_i])) {
						dd_take_action(dd_affirmative)
						key_triggered = true
					}
				}
				var input_count = array_length(gamepad_negative)
				for (var dd_i = 0; dd_i < input_count; ++dd_i) {
					if (gamepad_button_check(gp,gamepad_negative[dd_i])) {
						dd_take_action(dd_negative)
						key_triggered = true
					}
				}
				if (key_triggered = false) { // any other button 
					if (
						gamepad_button_check(gp,gp_face1) or 
						gamepad_button_check(gp,gp_face2) or 
						gamepad_button_check(gp,gp_face3) or 
						gamepad_button_check(gp,gp_face4) or 
						gamepad_button_check(gp,gp_padd) or 
						gamepad_button_check(gp,gp_padl) or 
						gamepad_button_check(gp,gp_padr) or 
						gamepad_button_check(gp,gp_padu) or 
						gamepad_button_check(gp,gp_select) or 
						gamepad_button_check(gp,gp_shoulderl) or 
						gamepad_button_check(gp,gp_shoulderlb) or 
						gamepad_button_check(gp,gp_shoulderr) or 
						gamepad_button_check(gp,gp_shoulderrb) or 
						gamepad_button_check(gp,gp_start) or 
						gamepad_button_check(gp,gp_stickl) or 
						gamepad_button_check(gp,gp_stickr) 
						) {
						dd_take_action(dd_anything)
					}
				}
				
			}
		}
	#endregion

}

function dd_draw_text(
				to_draw_x,		// <- Where to draw the whole text
				to_draw_y,		// <- Where to draw the whole text
				to_draw_text,	// <- Array of text
				to_draw_align,	// <- How you want the text alligned 
				to_draw_block_x,// <- Array of where each block of text should be
				to_draw_block_y,// <- Array of where each block of text should be
				to_draw_line,	// <- Array saying what line this block of text is on (if it wraps over many lines)
				to_draw_style,	// <- Array of what style should each block be 
				to_draw_effect,	// <- Array of what effect should each block be 
				to_draw_image	// <- Array of any images you want to draw (-1 for no image)
				) {
	
	
	var current_draw_style = -1
	var current_draw_effect = -1
	var width_so_far = 0
	
	var current_blocks_for_drawing = array_length(to_draw_text)
	for (var i = 0; i < current_blocks_for_drawing; ++i) {
			
		// offset for text align 
		switch (to_draw_align) {
		    case fa_left:
		        var text_draw_offset_x = to_draw_x-(text_area_width/2)
				var text_draw_offset_y = to_draw_y
				//draw_set_halign(fa_left)
		    break;
		    case fa_right:
		        var text_draw_offset_x = to_draw_x+(text_area_width/2) - running_x_for_line[to_draw_line[i]]
				var text_draw_offset_y = to_draw_y 
				draw_set_halign(fa_left)
		    break;
		    case fa_center:
				width_so_far += to_draw_block_x[i]
		        var text_draw_offset_x = to_draw_x - (running_x_for_line[to_draw_line[i]]/2)
				var text_draw_offset_y = to_draw_y
				//draw_set_halign(fa_right)
		    break;
		}
		
	
		// CHANGING THE STYLE
		if (to_draw_style[i] != current_draw_style) {
			current_draw_style = to_draw_style[i]
		
			draw_set_font(style_font[current_draw_style])
			draw_set_colour(style_colour[current_draw_style])
		}

		#region // ADDING ANY EFFECTS 
			var effect_x = 0
			var effect_y = 0
			var effect_scale_x = 1
			var effect_scale_y = 1
			var effect_angle = 0

			if (to_draw_effect[i] != -1) {
				if (to_draw_effect[i] != current_draw_effect or effect_letter_by_letter[to_draw_effect[i]] == true) {
					current_draw_effect = to_draw_effect[i]
		
					switch (current_draw_effect) {
					    case dd_effect.underline:
							var height_for_line = 17
					        draw_line(text_draw_offset_x+to_draw_block_x[i],text_draw_offset_y+to_draw_block_y[i]+height_for_line,text_draw_offset_x+to_draw_block_x[i]+string_width(to_draw_text[i]),text_draw_offset_y+to_draw_block_y[i]+height_for_line)
					    break;
					    case dd_effect.strikethrough:
							var height_for_line = 10
					        draw_line(text_draw_offset_x+to_draw_block_x[i],text_draw_offset_y+to_draw_block_y[i]+height_for_line,text_draw_offset_x+to_draw_block_x[i]+string_width(to_draw_text[i]),text_draw_offset_y+to_draw_block_y[i]+height_for_line)
					    break;
					    case dd_effect.wobble_word:
					    case dd_effect.wobble_letter:
							var effect_wobble_size = 1.2 // this number is doubled because it goes in both directions 
							effect_x = random_range(-effect_wobble_size,effect_wobble_size)
							effect_y = random_range(-effect_wobble_size,effect_wobble_size)
						break;
					    case dd_effect.sinewave_word_h:
						case dd_effect.sinewave_letter_h:
						
							// data step: 
							effects_data[i] += 0.2
						
							var effect_wobble_size = 3 // this number is doubled because it goes in both directions 
							effect_x = sin(effects_data[i])*effect_wobble_size
						break;
					    case dd_effect.sinewave_word_v:
						case dd_effect.sinewave_letter_v:
						
							// data step: 
							effects_data[i] += 0.2
						
							var effect_wobble_size = 3 // this number is doubled because it goes in both directions 
							effect_y = sin(effects_data[i])*effect_wobble_size
						break;
						case dd_effect.sinewave_word_scale:
						case dd_effect.sinewave_letter_scale:
							// data step: 
							effects_data[i] += 0.2
						
							var scale_amount = 0.1 // this number is doubled because it goes in both directions 
							effect_scale_x = 1 + (sin(effects_data[i])*scale_amount)
							effect_scale_y = effect_scale_x
						break;
					    case dd_effect.sinewave_word_h_slow:
						case dd_effect.sinewave_letter_h_slow:
						
							// data step: 
							effects_data[i] += 0.03
						
							var effect_wobble_size = 3 // this number is doubled because it goes in both directions 
							effect_x = sin(effects_data[i])*effect_wobble_size
						break;
					    case dd_effect.sinewave_word_v_slow:
						case dd_effect.sinewave_letter_v_slow:
						
							// data step: 
							effects_data[i] += 0.03
						
							var effect_wobble_size = 3 // this number is doubled because it goes in both directions 
							effect_y = sin(effects_data[i])*effect_wobble_size
						break;
						case dd_effect.sinewave_word_scale_slow:
						case dd_effect.sinewave_letter_scale_slow:
							// data step: 
							effects_data[i] += 0.03
						
							var scale_amount = 0.1 // this number is doubled because it goes in both directions 
							effect_scale_x = 1 + (sin(effects_data[i])*scale_amount)
							effect_scale_y = effect_scale_x
						break;
						case dd_effect.rainbow_short:
						
							draw_set_colour(rainbow_colour_palette_short[rainbow_colour mod array_length(rainbow_colour_palette_short)])
						
							rainbow_colour++
						break;
						case dd_effect.rainbow_long:
						
							draw_set_colour(rainbow_colour_palette_long[rainbow_colour mod array_length(rainbow_colour_palette_long)])
						
							rainbow_colour++
						break;
						case dd_effect.rainbow_animated_letter:
						case dd_effect.rainbow_animated_word:

							effects_data[i] += 0.2
							draw_set_colour(rainbow_colour_palette_long[(rainbow_colour+floor(effects_data[i])) mod array_length(rainbow_colour_palette_long)])
						break;
						case dd_effect.rotate_smooth:
							// data step: 
							effects_data[i] += 0.2
						
							var rotate_amount = 13 // this number is doubled because it goes in both directions 
							effect_angle = sin(effects_data[i])*rotate_amount
							effect_y = -2
						break;
						case dd_effect.rotate_letter_fixed:
							// data step: 
							if (effects_data[i] == 0) { 
								effects_data[i] = random_range(-8,8)
							}
						
							effect_angle = effects_data[i]
							effect_y = -2
						break;
					    case dd_effect.rotate_letter_shake:
						
							// data step: 
							if (effects_data[i] == 0) { 
								effects_data[i] = random_range(-8,8)
							}
						
							effect_angle = effects_data[i]
						
							var effect_wobble_size = 0.5 // this number is doubled because it goes in both directions 
							effect_x = random_range(-effect_wobble_size,effect_wobble_size)
							effect_y = random_range(-effect_wobble_size,effect_wobble_size) - 2
						break;
						case dd_effect.popping:
							// data step: 
							if (effects_data[i] == 0) {effects_data[i] = random(0.25)}
							effects_data[i] += 0.004
							if (effects_data[i] > 0.25) {effects_data[i] = 0.01}
						
							effect_scale_x = 0.9 + effects_data[i]
							effect_scale_y = effect_scale_x
							effect_y = -2
						break;
						case dd_effect.beat:
							// data step: 
							
							var beat_frames = 100
							effects_data[i] ++
							if (effects_data[i] > beat_frames) {effects_data[i] = 0}

							var scale_to_use = ee(ease.beat1,effects_data[i],beat_frames)
							effect_scale_x = 0.9 + (scale_to_use*0.2)
							effect_scale_y = effect_scale_x
							effect_y = +1 - (scale_to_use*5)
						break;
						case dd_effect.beatfast:
							// data step: 
							
							var beat_frames = 30
							effects_data[i] ++
							if (effects_data[i] > beat_frames) {effects_data[i] = 0}

							var scale_to_use = ee(ease.beat2,effects_data[i],beat_frames)
							effect_scale_x = 0.95 + (scale_to_use*0.13)
							effect_scale_y = effect_scale_x
							effect_y = 1-(scale_to_use*3)
						break;
						case dd_effect.squeeze_squish:
							// data step: 
							effects_data[i] += 0.08
						
							var scale_amount = 0.1 // this number is doubled because it goes in both directions 
							var sin_amount = (sin(effects_data[i])*scale_amount)
							effect_scale_x = 1 + sin_amount
							effect_scale_y = 1 - sin_amount
						
							effect_y = -1
						break;
						case dd_effect.bounce_word:
						case dd_effect.bounce_letter:
							// data step
							effects_data[i] ++
						
							var frames_for_animation = 130
							if (effects_data[i] > frames_for_animation) {
								effects_data[i] = 0
							}

							effect_y = -2-(ee2(ease.inCirc,ease.outBounce,effects_data[i],frames_for_animation,0.65,true)*4)
						break;
						case dd_effect.mexican_wave_word:
						case dd_effect.mexican_wave_letter:
							// data step
							effects_data[i] ++
						
							var frames_for_animation = 100
							if (effects_data[i] > frames_for_animation) {
								effects_data[i] = 0
							}

							effect_y = (ee2(ease.outCirc,ease.outQuad,effects_data[i],frames_for_animation,0.9,true)*3)-3
						break;
						case dd_effect.mexican_wave_scale:
							// data step
							effects_data[i] ++
						
							var frames_for_animation = 100
							if (effects_data[i] > frames_for_animation) {
								effects_data[i] = 0
							}

							effect_scale_x = 1+(0.25-(ee2(ease.outCirc,ease.outQuad,effects_data[i],frames_for_animation,0.8,true)*0.25))
							effect_scale_y = effect_scale_x
							effect_y = -1
						break;
						case dd_effect.mexican_wave_alpha:
							// data step
							effects_data[i] ++
						
							var frames_for_animation = 100
							if (effects_data[i] > frames_for_animation) {
								effects_data[i] = 0
							}

							draw_set_alpha(ee2(ease.outCirc,ease.outQuad,effects_data[i],frames_for_animation,0.8,true))
	
						break;
						case dd_effect.stroke1:
						
							draw_set_colour(c_white)
							var stroke_x = text_draw_offset_x+to_draw_block_x[i]+effect_x
							var stroke_y = text_draw_offset_y+to_draw_block_y[i]+effect_y
							draw_text_transformed(stroke_x+1,stroke_y+1,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x+1,stroke_y-1,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x-1,stroke_y+1,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x-1,stroke_y-1,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)

							draw_set_colour(style_colour[current_draw_style])
						break;
						case dd_effect.stroke2:
						
							draw_set_colour(c_white)
							var stroke_x = text_draw_offset_x+to_draw_block_x[i]+effect_x
							var stroke_y = text_draw_offset_y+to_draw_block_y[i]+effect_y
							draw_text_transformed(stroke_x+2,stroke_y+2,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x+2,stroke_y-2,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x-2,stroke_y+2,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x-2,stroke_y-2,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)

							draw_text_transformed(stroke_x+3,stroke_y,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x-3,stroke_y,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x,stroke_y+3,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x,stroke_y-3,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)

							draw_set_colour(style_colour[current_draw_style])
						break;
						case dd_effect.stroke_animated:
					
							// data step: 
							effects_data[i] += 0.07
						
							draw_set_alpha(0.5+(sin(effects_data[i])/2))
						
							var stroke_x = text_draw_offset_x+to_draw_block_x[i]+effect_x
							var stroke_y = text_draw_offset_y+to_draw_block_y[i]+effect_y
							draw_text_transformed(stroke_x+1,stroke_y+1,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x+1,stroke_y-1,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x-1,stroke_y+1,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x-1,stroke_y-1,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)

							draw_text_transformed(stroke_x+1,stroke_y,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x-1,stroke_y,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x,stroke_y+1,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x,stroke_y-1,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)

							draw_set_alpha(1)
							draw_set_colour(style_colour[current_draw_style])
						break;
						case dd_effect.stroke_animated_black:
						
							// data step: 
							effects_data[i] += 0.07
						
							draw_set_alpha(0.5+(sin(effects_data[i])/2))
						
							draw_set_colour(c_black)
							var stroke_x = text_draw_offset_x+to_draw_block_x[i]+effect_x
							var stroke_y = text_draw_offset_y+to_draw_block_y[i]+effect_y
							draw_text_transformed(stroke_x+1,stroke_y+1,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x+1,stroke_y-1,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x-1,stroke_y+1,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x-1,stroke_y-1,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)

							draw_text_transformed(stroke_x+1,stroke_y,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x-1,stroke_y,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x,stroke_y+1,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x,stroke_y-1,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)

							draw_set_alpha(1)
							draw_set_colour(style_colour[current_draw_style])
						break;
						case dd_effect.chromatic_aberration:
						
							var stroke_x = text_draw_offset_x+to_draw_block_x[i]
							var stroke_y = text_draw_offset_y+to_draw_block_y[i]
							draw_set_colour(c_red)
							draw_text_transformed(stroke_x-2,stroke_y,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_set_colour(c_aqua)
							draw_text_transformed(stroke_x+2,stroke_y,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)

							draw_set_colour(style_colour[current_draw_style])
						break;
						case dd_effect.shadow1:
						
							draw_set_colour(c_black)
							var stroke_x = text_draw_offset_x+to_draw_block_x[i]+effect_x
							var stroke_y = text_draw_offset_y+to_draw_block_y[i]+effect_y
							draw_text_transformed(stroke_x+1,stroke_y+1,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)

							draw_set_font(style_font[current_draw_style])
							draw_set_colour(style_colour[current_draw_style])
						break;
						case dd_effect.shadow2:
						
							draw_set_colour(c_black)
							var stroke_x = text_draw_offset_x+to_draw_block_x[i]+effect_x
							var stroke_y = text_draw_offset_y+to_draw_block_y[i]+effect_y
							draw_text_transformed(stroke_x+2,stroke_y+2,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x+1,stroke_y+1,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x+1,stroke_y,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)
							draw_text_transformed(stroke_x,stroke_y+1,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)

							draw_set_font(style_font[current_draw_style])
							draw_set_colour(style_colour[current_draw_style])
						break;
						case dd_effect.flash:
						
							// data step: 
							effects_data[i] += 0.2
						
							var scale_amount = 0.1 // this number is doubled because it goes in both directions 
							draw_set_alpha((sin(effects_data[i])/2)+0.5)

						break;
						case dd_effect.heart_beat_word:
						case dd_effect.heart_beat_letter:
						
							effects_data[i] ++
						
							var frames_for_animation = 100
							if (effects_data[i] > frames_for_animation) {
								effects_data[i] = 0
							}
						
							effect_scale_x = 1 + (ee(ease.heartbeat,effects_data[i],frames_for_animation)*0.2)
							effect_scale_y = effect_scale_x
if (i == 105) {

//show_debug_message("sss")
//show_debug_message(effects_data[i])
//show_debug_message(frames_for_animation)
//show_debug_message(ee(ease.heartbeat,effects_data[i],frames_for_animation))

}
						break;
						case dd_effect.heart_beat_alpha:
						
							effects_data[i] ++
						
							var frames_for_animation = 100
							if (effects_data[i] > frames_for_animation) {
								effects_data[i] = 0
							}
						
							draw_set_alpha(1-ee(ease.heartbeat,effects_data[i],frames_for_animation))

						break;
						case dd_effect.flicker_alpha:
							effects_data[i] ++
						
							var frames_for_animation = 150
							if (effects_data[i] > frames_for_animation) {
								effects_data[i] = 0
							}
						
							draw_set_alpha(ee2(ease.on,ease.flicker1,effects_data[i],frames_for_animation,0.6,false))
						break;
						case dd_effect.flicker_alpha_constant:
							effects_data[i] ++
						
							var frames_for_animation = 170
							if (effects_data[i] > frames_for_animation) {
								effects_data[i] = 0
							}
						
							draw_set_alpha(ee(ease.flicker2,effects_data[i],frames_for_animation))
						break;
						case dd_effect.intro_alpha_slow:
							if (effects_data[i] < 1) {
								effects_data[i] += 0.007
								if (effects_data[i] > 1) {
									effects_data[i] = 1
								}
							}

							draw_set_alpha(effects_data[i])
						break;
						case dd_effect.intro_alpha_fast:
							if (effects_data[i] < 1) {
								effects_data[i] += 0.02
								if (effects_data[i] > 1) {
									effects_data[i] = 1
								}
							}

							draw_set_alpha(effects_data[i])
						break;
						case dd_effect.intro_top_with_alpha:
							if (effects_data[i] < 1) {
								effects_data[i] += 0.05
								if (effects_data[i] > 1) {
									effects_data[i] = 1
								}
							}

							draw_set_alpha(effects_data[i])
							effect_y = -10  + (effects_data[i]*10)
						break;
						case dd_effect.intro_bottom_right:
							if (effects_data[i] < 1) {
								effects_data[i] += 0.05
								if (effects_data[i] > 1) {
									effects_data[i] = 1
								}
							}

							effect_x = +8  - (effects_data[i]*8)
							effect_y = effect_x/2
						break;
						case dd_effect.intro_big_to_normal:
							if (effects_data[i] < 1) {
								effects_data[i] += 0.03
								if (effects_data[i] > 1) {
									effects_data[i] = 1
								}
							}

							effect_scale_x = 2  - (effects_data[i])
							effect_scale_y = effect_scale_x
						
							draw_set_alpha(effects_data[i])
						break;
						case dd_effect.intro_small_to_normal:
							if (effects_data[i] < 1) {
								effects_data[i] += 0.03
								if (effects_data[i] > 1) {
									effects_data[i] = 1
								}
							}

							effect_scale_x = effects_data[i]
							effect_scale_y = effect_scale_x
						break;
						case dd_effect.intro_fall_in:
							if (effects_data[i] < 1) {
								effects_data[i] += 0.03
								if (effects_data[i] > 1) {
									effects_data[i] = 1
								}
							}

							effect_y = -11+(ee(ease.inCirc,effects_data[i],1)*11)
						break;
						case dd_effect.intro_slide_right:
							if (effects_data[i] < 1) {
								effects_data[i] += 0.01
								if (effects_data[i] > 1) {
									effects_data[i] = 1
								}
							}

							effect_x = 50-(ee(ease.outCirc,effects_data[i],1)*50)
						break;
						case dd_effect.intro_black_to_grey:
							if (effects_data[i] < 120) {
								effects_data[i] ++
							}
							var number_to_colours = 10

							draw_set_colour(black_to_grey_palette[round(effects_data[i]/12)])
						break;
						case dd_effect.intro_white_to_grey:
							if (effects_data[i] < 120) {
								effects_data[i] ++
							}
							var number_to_colours = 10

							draw_set_colour(white_to_grey_palette[round(effects_data[i]/12)])
						break;
						case dd_effect.intro_red_to_grey:
							if (effects_data[i] < 120) {
								effects_data[i] ++
							}
							var number_to_colours = 10

							draw_set_colour(red_to_grey_palette[round(effects_data[i]/12)])
						break;
						case dd_effect.intro_wobble:
							if (effects_data[i] < 1) {
								effects_data[i] += 0.005
								if (effects_data[i] > 1) {
									effects_data[i] = 1
								}
							}
						
							var effect_wobble_size = (1-effects_data[i])*3
						
							effect_x = random_range(-effect_wobble_size,effect_wobble_size)
							effect_y = random_range(-effect_wobble_size,effect_wobble_size)
						break;
						case dd_effect.intro_sine_v:

							// data step: 
							effects_data[i] += 0.15
						
							var effect_wobble_size = 6-(effects_data[i]/3) // this number is doubled because it goes in both directions 
							if (effect_wobble_size > 0.5) {
								effect_y = sin(effects_data[i])*effect_wobble_size
							}
						break;
						case dd_effect.intro_wind_in:

							// data step: 
							effects_data[i] += 0.3
						
							var effect_wobble_size = 6-(effects_data[i]/2) // this number is doubled because it goes in both directions 
							if (effect_wobble_size > 0.1) {
								effect_wobble_size*=3
								effect_y = (sin(effects_data[i])*effect_wobble_size)
								effect_x = (cos(effects_data[i])*effect_wobble_size) + (effect_wobble_size*4)
							}
						break;
						case dd_effect.intro_chromatic_aberration:

							// data step: 
							effects_data[i] += 0.03
							if (effects_data[i] > pi) {effects_data[i] = pi}
							var move_amount = (sin(effects_data[i])*3)
								
							var stroke_x = text_draw_offset_x+to_draw_block_x[i]
							var stroke_y = text_draw_offset_y+to_draw_block_y[i]

							draw_set_colour(c_red)
							draw_text_transformed(stroke_x-move_amount,stroke_y-0.5,to_draw_text[i],effect_scale_x+0.05,effect_scale_y+0.05,effect_angle)
							draw_set_colour(c_aqua)
							draw_text_transformed(stroke_x+move_amount,stroke_y-0.5,to_draw_text[i],effect_scale_x+0.05,effect_scale_y+0.05,effect_angle)

							draw_set_colour(style_colour[current_draw_style])

						break;
						case dd_effect.intro_big_height_small_width:
							if (effects_data[i] < 1) {
								effects_data[i] += 0.03
								if (effects_data[i] > 1) {
									effects_data[i] = 1
								}
							}

							effect_scale_x = effects_data[i]
							effect_scale_y = 2-effect_scale_x
						
							draw_set_alpha(effects_data[i])
						break;
						case dd_effect.intro_big_width_small_height:
							if (effects_data[i] < 1) {
								effects_data[i] += 0.03
								if (effects_data[i] > 1) {
									effects_data[i] = 1
								}
							}

							effect_scale_y = effects_data[i]
							effect_scale_x = 4-(effect_scale_y*3)
						
							draw_set_alpha(effects_data[i])
						break;
						case dd_effect.intro_fadein_thendull_1s:
							var fade_frames_in = 60
							var fade_frames_out = 90
							var fade_frames_wait = 60
							
							effects_data[i] ++
							if (effects_data[i] < fade_frames_in) { // fade in 
								draw_set_alpha(ee(ease.linear,effects_data[i],fade_frames_in))
							} else if (effects_data[i] < fade_frames_in + fade_frames_wait) { // full opaque 
								draw_set_alpha(1)
							} else if (effects_data[i] < fade_frames_in + fade_frames_wait + fade_frames_out) {
								draw_set_alpha(1-(ee(ease.linear,effects_data[i]-(fade_frames_in + fade_frames_wait),fade_frames_out)*0.7))
							} else {
								draw_set_alpha(0.3)
							}
						break;
						case dd_effect.intro_fadein_thendull_2s:

							var fade_frames_in = 60
							var fade_frames_out = 90
							var fade_frames_wait = 120
							
							effects_data[i] ++
							if (effects_data[i] < fade_frames_in) { // fade in 
								draw_set_alpha(ee(ease.linear,effects_data[i],fade_frames_in))
							} else if (effects_data[i] < fade_frames_in + fade_frames_wait) { // full opaque 
								draw_set_alpha(1)
							} else if (effects_data[i] < fade_frames_in + fade_frames_wait + fade_frames_out) {
								draw_set_alpha(1-(ee(ease.linear,effects_data[i]-(fade_frames_in + fade_frames_wait),fade_frames_out)*0.7))
							} else {
								draw_set_alpha(0.3)
							}
						break;
						case dd_effect.intro_fadein_thendull_3s:
							var fade_frames_in = 60
							var fade_frames_out = 90
							var fade_frames_wait = 180

							effects_data[i] ++
							if (effects_data[i] < fade_frames_in) { // fade in 
								draw_set_alpha(ee(ease.linear,effects_data[i],fade_frames_in))
							} else if (effects_data[i] < fade_frames_in + fade_frames_wait) { // full opaque 
								draw_set_alpha(1)
							} else if (effects_data[i] < fade_frames_in + fade_frames_wait + fade_frames_out) {
								draw_set_alpha(1-(ee(ease.linear,effects_data[i]-(fade_frames_in + fade_frames_wait),fade_frames_out)*0.7))
							} else {
								draw_set_alpha(0.3)
							}
						break;


					}
				}	
			}
		#endregion

		// DRAW THE ACTUAL TEXT
		draw_text_transformed(text_draw_offset_x+to_draw_block_x[i]+effect_x,text_draw_offset_y+to_draw_block_y[i]+effect_y,to_draw_text[i],effect_scale_x,effect_scale_y,effect_angle)

		draw_set_alpha(1)

		if (to_draw_image[i] != -1) { // draw any inline sprites
			draw_sprite(to_draw_image[i],0,text_draw_offset_x+to_draw_block_x[i],text_draw_offset_y+to_draw_block_y[i])
		}

	}
}

function dd_reply_move_up() {
	selected_reply --
	if (selected_reply < 0) { // loop around
		selected_reply = dd_responce_count[dd_to_display]-1
	}
}

function dd_reply_move_down() {
	selected_reply ++
	if (selected_reply > dd_responce_count[dd_to_display]-1) { // loop around
		selected_reply = 0
	}
}

/* INTERNAL DONT USE THESE */

function dd_internal_new_block() {
	frames_per_character_temp = style_speed[style_current] // the markup can change the speed of the text
	block_number++
	data_maintext_text[block_number] = "" // start a new block
	data_maintext_style[block_number] = style_current
	data_maintext_effect[block_number] = style_effect[style_current]
	data_maintext_image[block_number] = -1
	data_maintext_x[block_number+1] = running_x // always one more because this is the x of the next text
	data_maintext_y[block_number+1] = running_y // always one more because this is the x of the next text
	data_maintext_line[block_number] = line_count // what line is this block on
	
	effects_data[block_number] = 0
}

function dd_internal_new_line() {
	line_count ++
	running_x_for_line[line_count] = 0
	running_x = 0
	running_y += line_height
	data_maintext_x[block_number+1] = 0 
	data_maintext_y[block_number+1] = running_y
	
	dd_internal_new_block() // for a new line also start a new block
}