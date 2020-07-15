/// @description EaseHeartbeat(inputvalue,outputmin,outputmax,inputmax)
/// @function EaseHeartbeat
/// @param inputvalue
/// @param outputmin
/// @param outputmax
/// @param inputmax

function EaseHeartbeat() {
	return ((ease_combine(
				e3(ease.outQuad,ease.inOutQuad,ease.off,argument0,argument3,0.20,0.75,true,false), // sine after it 
				e3(ease.off,ease.waveSine,ease.waveSine,argument3-argument0,argument3,0.6,0.8,false,false)*1.05 // double pulse
			,0.4)*(argument2-argument1))+argument1)
}