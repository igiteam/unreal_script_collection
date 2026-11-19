class TurokUIKeyPosition extends TurokUIKeyFrame
    native;

var @NULL Position;

// Export UTurokUIKeyPosition::execInterpolate(FFrame&, void* const)
native function @NULL Interpolate(float delta_time, float end_time, @NULL end_val, byte end_mode);
