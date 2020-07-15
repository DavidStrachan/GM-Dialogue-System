/// @function in_array
/// @param needle 
/// @param haystack

function in_array(needle,haystack) {

	var countarray = array_length(haystack);

	var i;
	for (i = 0; i < countarray; i ++) {
	    if (haystack[i] == needle) {
	        return true;
	    }
	}

	return false

}