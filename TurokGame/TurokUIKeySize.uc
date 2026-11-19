class TurokUIKeySize extends TurokUIKeyFrame
    native;

var @NULL Size;

// Export UTurokUIKeySize::execInterpolate(FFrame&, void* const)
native function @NULL Interpolate(float delta_time, float end_time, @NULL end_val, byte end_mode);
