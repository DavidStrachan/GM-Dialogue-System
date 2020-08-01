/// @description Insert description here
// You can write your code in this editor


if (display == 2) { // draw the dialogue 
	
	rainbow_colour = 0 // I hate keeping a count here just for rainbow but it needs to be somewhere 
	
	draw_set_valign(fa_top)
	draw_set_halign(fa_left)
	
	// background
	draw_sprite(spr_dialogue_bg,0,pos_background_x,pos_background_y)
	// character images 
	if (dd_image_left[dd_to_display] != -1) {
		draw_sprite_ext(dd_image_left[dd_to_display],0,pos_image_left_x,pos_image_left_y,1,1,0,c_white,1)
	}
	if (dd_image_right[dd_to_display] != -1) {
		draw_sprite_ext(dd_image_right[dd_to_display],0,pos_image_right_x,pos_image_right_y,-1,1,0,c_white,1)
	}


	// draw the text: 
	dd_draw_text(pos_text_x,pos_text_y,data_maintext_text,dd_align[dd_to_display],data_maintext_x,data_maintext_y,data_maintext_line,data_maintext_style,data_maintext_effect,data_maintext_image)
	// draw the name: 
	dd_draw_text(pos_name_x,pos_name_y,[dd_speaker_name[dd_to_display]+":"],fa_left,[0],[0],[0],[dd_speaker_name_style[dd_to_display]],[style_effect[dd_speaker_name_style[dd_to_display]]],[-1])
	

	//dd_draw_text(pos_text_x+cos(current_time/1000)*100,pos_text_y-200+sin(current_time/1000)*100,data_maintext_text,fa_right,data_maintext_x,data_maintext_y,data_maintext_line,data_maintext_style,data_maintext_effect,data_maintext_image)
	//dd_draw_text(pos_text_x,pos_text_y-400,data_maintext_text,fa_center,data_maintext_x,data_maintext_y,data_maintext_line,data_maintext_style,data_maintext_effect,data_maintext_image)
	
	
	
	// You can put anything here you want to be drawn once all the text has been typed out
	if (type_out_complete == true) {
		
		#region display replies 

		for (var i = 0; i < dd_responce_count[dd_to_display]; ++i) {
			if (selected_reply == i) { // selected reply 
				dd_draw_text(pos_reply_x,running_y+pos_text_y+((i+2)*line_height_reply),[reply_selected_start+dd_responce_text[dd_to_display][i]+reply_selected_end],fa_left,[0],[0],[0],[dd_responce_style_selected[dd_to_display][i]],[style_effect[dd_responce_style_selected[dd_to_display][i]]],[-1])				
			} else { // not selected 
				dd_draw_text(pos_reply_x,running_y+pos_text_y+((i+2)*line_height_reply),[dd_responce_text[dd_to_display][i]],fa_left,[0],[0],[0],[dd_responce_style[dd_to_display][i]],[style_effect[dd_responce_style[dd_to_display][i]]],[-1])
			}
		}
		#endregion
	}

} else if (display == 1) { // animate in
	var ease_amount = ee(ease.outBack,animate_in_frame,animate_in_frames)
	
	draw_sprite_ext(spr_dialogue_bg,0,pos_background_x,pos_background_y,ease_amount,ease_amount,0,c_white,ease_amount)
	if (dd_image_left[dd_to_display] != -1) {  
		draw_sprite_ext(dd_image_left[dd_to_display],0,pos_image_left_x,pos_image_left_y,ease_amount,ease_amount,0,c_white,ease_amount)
	}
	if (dd_image_right[dd_to_display] != -1) {
		draw_sprite_ext(dd_image_right[dd_to_display],0,pos_image_right_x,pos_image_right_y,ease_amount*-1,ease_amount,0,c_white,ease_amount)
	}
} else if (display == 3) { // animate out
	var ease_amount = 1-ee(ease.outCirc,animate_out_frame,animate_out_frames)
	
	draw_sprite_ext(spr_dialogue_bg,0,pos_background_x,pos_background_y,ease_amount,ease_amount,0,c_white,ease_amount)
	if (dd_image_left[dd_to_display] != -1) {
		draw_sprite_ext(dd_image_left[dd_to_display],0,pos_image_left_x,pos_image_left_y,ease_amount,ease_amount,0,c_white,ease_amount)
	}
	if (dd_image_right[dd_to_display] != -1) {
		draw_sprite_ext(dd_image_right[dd_to_display],0,pos_image_right_x,pos_image_right_y,ease_amount*-1,ease_amount,0,c_white,ease_amount)
	}
}

