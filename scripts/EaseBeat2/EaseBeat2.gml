/// @description EaseBeat2(inputvalue,outputmin,outputmax,inputmax)
/// @function EaseBeat2
/// @param inputvalue
/// @param outputmin
/// @param outputmax
/// @param inputmax

function EaseBeat2() {
	return ((e2(ease.inQuint,ease.outQuad,argument3-argument0,argument3,0.9,true)*(argument2-argument1))+argument1)
}