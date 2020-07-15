/// @description EaseBeat1(inputvalue,outputmin,outputmax,inputmax)
/// @function EaseBeat1
/// @param inputvalue
/// @param outputmin
/// @param outputmax
/// @param inputmax

function EaseBeat1() {
	return ((e3(ease.outQuad,ease.inOutQuad,ease.off,argument0,argument3,0.25,0.85,true,false)*(argument2-argument1))+argument1)
}