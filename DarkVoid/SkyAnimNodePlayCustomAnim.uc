class SkyAnimNodePlayCustomAnim extends AnimNodePlayCustomAnim
    native;

var float CustomAnimEndTime;

// Export USkyAnimNodePlayCustomAnim::execPlayCustomAnimDatum(FFrame&, void* const)
native function float PlayCustomAnimDatum(out InteractionAnimInfo AnimDatum, optional bool bOverride);

// Export USkyAnimNodePlayCustomAnim::execOnChildAnimEnd(FFrame&, void* const)
native function OnChildAnimEnd(AnimNodeSequence Child, float PlayedTime, float ExcessTime, AnimNode ImmediateChild);
