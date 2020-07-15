/// @description Lightning1(inputvalue,outputmin,outputmax,inputmax)
/// @function Lightning1 
/// @param inputvalue
/// @param outputmin
/// @param outputmax
/// @param inputmax


function Lightning1 () {
	return ((easing5(ease.linear,ease.outBounce,ease.outBounce,ease.linear,ease.outExpo,argument0,argument3,0.05,0.2,0.3,0.35,true,true,false,true)*(argument2-argument1))+argument1)
}
