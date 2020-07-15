/// @decription end the timer and output how long the code took between this 
/// @function time_debug_end

gml_pragma("forceinline");

var debug_end_time = get_timer()

show_debug_message("CODE TOOK: " + string(debug_end_time-global.debug_start_time) + "µs (microseconds)")