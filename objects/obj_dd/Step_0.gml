/// @description Insert description here
// You can write your code in this editor



if (display == 2) {

	#region for putting the next letter/letters into the array so they can be drawn 

	frame--
	if (skip_typeout) {frame = 0} // we dont want to wait to type out the text
	
	while (frame < 1 and type_out_complete == false) {

		var new_character_to_add = string_char_at(dd_text[dd_to_display],character_along)
		
		var add_character = true
		
		// find out if this is a special character 
		if (in_array(new_character_to_add,frames_per_character_fast_char)) { // fast 
			frame += frames_per_character_fast
		} else if (in_array(new_character_to_add,frames_per_character_slow_char)) {
			frame += frames_per_character_slow
		} else if (in_array(new_character_to_add,frames_per_character_very_slow_char)) {
			frame += frames_per_character_very_slow
		} else if (new_character_to_add == markup_character_start) { // markup 
			// find out what style they want to change to 
			
			#region STYLE MARKUP
				for (var i = 0; i < dd_style.size; ++i) {
				    if (string_copy(dd_text[dd_to_display],character_along+1,style_markup_length[i]) == style_markup[i]) {
						style_last = style_current
						style_current = i	
						character_along+=style_markup_length[i]

						break;
					}
				}
						
				if (style_last != style_current) { // they have changed style
					add_character = false
					dd_internal_new_block()
				}
			
			#endregion
			#region SOUND MARKUP
				for (var i = 0; i < dd_inlineable_sound.size; ++i) {
				    if (string_copy(dd_text[dd_to_display],character_along+1,inlineable_sound_markup_length[i]) == inlineable_sound_markup[i]) {
						
						// REPLACE THIS WITH YOUR OWN SYSTEM FOR PLAYING SOUND
						audio_play_sound(inlineable_sound_file[i],1,false)
						
						add_character = false
						
						character_along+=inlineable_sound_markup_length[i] // this stops the markup from being displayed

						break;
					}
				}
			
			#endregion
			#region SCRIPT MARKUP
				for (var i = 0; i < dd_inlineable_script.size; ++i) {
				    if (string_copy(dd_text[dd_to_display],character_along+1,inlineable_script_markup_length[i]) == inlineable_script_markup[i]) {
						
						// REPLACE THIS WITH YOUR OWN SYSTEM FOR PLAYING SOUND
						script_execute(inlineable_script[i])
						
						add_character = false
						
						character_along+=inlineable_script_markup_length[i] // this stops the markup from being displayed

						break;
					}
				}
			
			#endregion
			#region SCREENSHAKE MARKUP
				for (var i = 0; i < dd_inlineable_screenshake.size; ++i) {
				    if (string_copy(dd_text[dd_to_display],character_along+1,inlineable_screenshake_markup_length[i]) == inlineable_screenshake_markup[i]) {
						
						// REPLACE THIS WITH YOUR OWN SYSTEM FOR SCREENSHAKE
						window_set_position(inlineable_screenshake_data[i],inlineable_screenshake_data[i])
						
						add_character = false
						
						character_along+=inlineable_screenshake_markup_length[i] // this stops the markup from being displayed

						break;
					}
				}
			
			#endregion
			#region IMAGE MARKUP
				for (var i = 0; i < dd_inlineable_image.size; ++i) {
				    if (string_copy(dd_text[dd_to_display],character_along+1,inlineable_image_markup_length[i]) == inlineable_image_markup[i]) {
						
						dd_internal_new_block()
						
						data_maintext_image[block_number] = inlineable_image_sprite[i]

						add_character = false
						
						data_maintext_x[block_number+1] += inlineable_image_width[i]
						running_x_for_line[line_count] += inlineable_image_width[i]
						running_x += inlineable_image_width[i]
						
						character_along+=inlineable_image_markup_length[i] // this stops the markup from being displayed

						dd_internal_new_block()

						break;
					}
				}
			
			#endregion
			#region CODE MARKUP
				for (var i = 0; i < dd_inlineable_code.size; ++i) {
				    if (string_copy(dd_text[dd_to_display],character_along+1,inlineable_code_markup_length[i]) == inlineable_code_markup[i]) {
						
						if (i == dd_inlineable_code.linebreak) {
							
							dd_internal_new_line()
						
							add_character = false
			
							character_along+=inlineable_code_markup_length[i] // this stops the markup from being displayed
							
							frame = 0 // sometimes no delay after markup
							
							break;
							
						} else if (i == dd_inlineable_code.delay_1s) {
							frame = 60
							
							add_character = false
			
							character_along+=inlineable_code_markup_length[i] // this stops the markup from being displayed
							
							break;
						} else if (i == dd_inlineable_code.delay_2s) {
							frame = 120
							
							add_character = false
			
							character_along+=inlineable_code_markup_length[i] // this stops the markup from being displayed
							
							break;
						} else if (i == dd_inlineable_code.delay_3s) {
							frame = 180
							
							add_character = false
			
							character_along+=inlineable_code_markup_length[i] // this stops the markup from being displayed
							
							break;
						} else if (i == dd_inlineable_code.delay_4s) {
							frame = 240
							
							add_character = false
			
							character_along+=inlineable_code_markup_length[i] // this stops the markup from being displayed
							
							break;
						}
					}
				}
			
			#endregion

		} else { // standard speed 
			frame += frames_per_character_temp
		}
		
		if (add_character == true) { // to stop the markup character from being added
			data_maintext_text[block_number] += new_character_to_add
			// find the width of this character 
			draw_set_font(style_font[style_current])
			var character_width = string_width(new_character_to_add)
			data_maintext_x[block_number+1] += character_width // always one more because this is the x of the next text
			running_x += character_width
			running_x_for_line[line_count] += character_width
			
			// some effects want each letter to be their own block
			if (effect_letter_by_letter[style_effect[style_current]]) { 
				dd_internal_new_block()
			}
			
			if (running_x > text_area_width) { // new line 
				dd_internal_new_line()
			}
		}
		
		character_along ++
		if (character_along > string_length(dd_text[dd_to_display])) {
			type_out_complete = true
		}
	}

	#endregion
	
	if (type_out_complete == true) {
		
		#region // navigate the dialogue 
			#region // mouse navigate
				if (mouse_x != mouse_x_last or mouse_y != mouse_y_last) {
					mouse_x_last = mouse_x
					mouse_y_last = mouse_y
		
					var mouse_check_left = pos_reply_x-(text_area_width/2)
					var mouse_check_right = mouse_check_left+text_area_width
					for (var i = 0; i < dd_responce_count[dd_to_display]; ++i) { // this is duplicated for hover and click
						if (point_in_rectangle(mouse_x,mouse_y,mouse_check_left,running_y+pos_text_y+((i+2)*line_height_reply),mouse_check_right,running_y+pos_text_y+((i+3)*line_height_reply))) {
							selected_reply = i
						}
					}
					if (mouse_y < mouse_outside_box) { // mouse is outside the box so deselect everything 
						selected_reply = -1
					}
					
				}
				if (mouse_wheel_up()) {
					dd_reply_move_up()
				}
				if (mouse_wheel_down()) {
					dd_reply_move_down()
				}
			#endregion
			#region keyboard navigate
				var key_count = array_length(keyboard_up)
				for (var i = 0; i < key_count; i++;) {
				   if (keyboard_check_pressed(keyboard_up[i])) {
					   dd_reply_move_up()
				   }
				}
				var key_count = array_length(keyboard_down)
				for (var i = 0; i < key_count; i++;) {
				   if (keyboard_check_pressed(keyboard_down[i])) {
					   dd_reply_move_down()
				   }
				}
			#endregion
			#region gamepad navigate
				var gp_num = gamepad_get_device_count();
				
				var key_up_count = array_length(gamepad_up)
				var key_down_count = array_length(gamepad_down)
				
				for (var gp = 0; gp < gp_num; gp++;) {
					if (gamepad_is_connected(gp)) {
						
						// a little bit to setup gamepads 
						if (array_length(gamepad_countdown) < gp) {
							gamepad_countdown[gp] = [0,0]
						}
						
						// countdown the delay until joystick inputs can be used 

						var gamepad_joystick_id = 0
						var gamepad_axis_name = gp_axislv
						if (gamepad_left_stick_on == true) {
							
							// cooldown for this joystick
							gamepad_countdown[gp][gamepad_joystick_id] -- 
							if (gamepad_countdown[gp][gamepad_joystick_id] < 0) {gamepad_countdown[gp][gamepad_joystick_id] = 0}
							
							if (gamepad_countdown[gp][gamepad_joystick_id] <= 0) {
								if (gamepad_axis_value(gp,gamepad_axis_name) > gamepad_deadzone_outer) {
									dd_reply_move_down()
									gamepad_countdown[gp][gamepad_joystick_id] = gamepad_delay
								}
								if (gamepad_axis_value(gp,gamepad_axis_name) < -gamepad_deadzone_outer) {
									dd_reply_move_up()
									gamepad_countdown[gp][gamepad_joystick_id] = gamepad_delay
								}
							}
							if (gamepad_axis_value(gp,gamepad_axis_name) < gamepad_deadzone_outer and gamepad_axis_value(gp,gamepad_axis_name) > -gamepad_deadzone_outer) {
								gamepad_countdown[gp][gamepad_joystick_id] = 0 // this allows players to use the joystick again without a cooldown
							}
						}
						var gamepad_joystick_id = 1
						var gamepad_axis_name = gp_axisrv
						if (gamepad_right_stick_on == true) {
							
							// cooldown for this joystick
							gamepad_countdown[gp][gamepad_joystick_id] -- 
							if (gamepad_countdown[gp][gamepad_joystick_id] < 0) {gamepad_countdown[gp][gamepad_joystick_id] = 0}
							
							
							if (gamepad_countdown[gp][gamepad_joystick_id] <= 0) {
								if (gamepad_axis_value(gp,gamepad_axis_name) > gamepad_deadzone_outer) {
									dd_reply_move_down()
									gamepad_countdown[gp][gamepad_joystick_id] = gamepad_delay
								}
								if (gamepad_axis_value(gp,gamepad_axis_name) < -gamepad_deadzone_outer) {
									dd_reply_move_up()
									gamepad_countdown[gp][gamepad_joystick_id] = gamepad_delay
								}
							}
							if (gamepad_axis_value(gp,gamepad_axis_name) < gamepad_deadzone_outer and gamepad_axis_value(gp,gamepad_axis_name) > -gamepad_deadzone_outer) {
								gamepad_countdown[gp][gamepad_joystick_id] = 0 // this allows players to use the joystick again without a cooldown
							}
						}

				   
						for (var i = 0; i < key_up_count; i++;) {
							if (gamepad_button_check_pressed(gp,gamepad_up[i])) {
								dd_reply_move_up()
							}
						}
						for (var i = 0; i < key_down_count; i++;) {
							if (gamepad_button_check_pressed(gp,gamepad_down[i])) {
								dd_reply_move_down()
							}
						}
					}
				}
			#endregion
		#endregion
		
		// typing out finished 
		if (selected_reply > -1) {
			dd_detect_input(dd_responce_action[dd_to_display][selected_reply],dd_negative_pressed[dd_to_display],dd_anything_pressed[dd_to_display])
		} else { // either no reply selected or there is no replies you can make
			dd_detect_input(dd_affirmative_pressed[dd_to_display],dd_negative_pressed[dd_to_display],dd_anything_pressed[dd_to_display])	
		}
		
		// look for mouse click (mouse click outside of dialogue counts as anything click on reply counts as affirmative) 
		if (mouse_check_button_pressed(mb_left)) {
			if (mouse_y < mouse_outside_box) { // I count this as clicking outside the dialogue 
				dd_take_action(dd_anything_pressed[dd_to_display])
			}
			
			if (selected_reply > -1) {
				var mouse_check_left = pos_reply_x-(text_area_width/2)
				var mouse_check_right = mouse_check_left+text_area_width
				for (var i = 0; i < dd_responce_count[dd_to_display]; ++i) { // this is duplicated for hover and click
					if (point_in_rectangle(mouse_x,mouse_y,mouse_check_left,running_y+pos_text_y+((i+2)*line_height_reply),mouse_check_right,running_y+pos_text_y+((i+3)*line_height_reply))) {
						dd_take_action(dd_responce_action[dd_to_display][selected_reply])
					}
				}
			}
		}
		
		frame = 0 // if they look at more dialogue after reset this so it doesnt keep counting down
		
	} else { // still typing out 
		
		dd_detect_input(dd_affirmative_pressed_during_talking[dd_to_display],dd_negative_pressed_during_talking[dd_to_display],dd_anything_pressed_during_talking[dd_to_display])
		if (mouse_check_button_pressed(mb_left)) { // handle mouse click when animating in 
			dd_take_action(dd_affirmative_pressed_during_talking[dd_to_display])
		}
		
	}

} else if (display == 1) { // animate in 
	animate_in_frame++

	dd_detect_input(dd_affirmative_pressed_during_talking[dd_to_display],dd_negative_pressed_during_talking[dd_to_display],dd_anything_pressed_during_talking[dd_to_display])
	if (mouse_check_button_pressed(mb_left)) { // handle mouse click when animating in 
		dd_take_action(dd_affirmative_pressed_during_talking[dd_to_display])
	}
	
	
	if (animate_in_frame > animate_in_frames) {
		display = 2
	}
} else if (display == 3) { // animate out 
	animate_out_frame++
	if (animate_out_frame > animate_out_frames) {
		display = 0
	}
}

