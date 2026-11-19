class CCKey extends Object
    native
    editinlinenew
    hidecategories(Object);

const CC_DURATION_INFINITE = -1.0;

var(Key) float Duration_sec;
var(Key) bool bDeadSpace;
var transient float EndTime_sec;

// Export UCCKey::execGetDuration_sec(FFrame&, void* const)
native function float GetDuration_sec();

// Export UCCKey::execIsDurationInfinite(FFrame&, void* const)
native static function bool IsDurationInfinite(float InDuration_sec);

function string GetDebugString()
{
    return (("EndTime_sec=" $ string(EndTime_sec)) $ ", bDeadSpace=") $ string(bDeadSpace);
    //return ReturnValue;    
}

defaultproperties
{
    Duration_sec=-1.0000000
}