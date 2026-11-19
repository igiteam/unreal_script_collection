class TurokUIKeyRotation extends TurokUIKeyFrame
    native;

var @NULL Rotation;
var @NULL Pivot;

// Export UTurokUIKeyRotation::execInterpolate(FFrame&, void* const)
native function Interpolate(float delta_time, float end_time, @NULL end_rot, @NULL end_pivot, byte end_mode, out @NULL out_Rot, out @NULL out_pivot);
