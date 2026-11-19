class TurokAnimNotify_CameraShake extends AnimNotify
    native
    editinlinenew
    collapsecategories
    hidecategories(Object);

enum EAnimShakePresets
{
    EASP_Smallest,                  // 0
    EASP_Smaller,                   // 1
    EASP_Medium,                    // 2
    EASP_Larger,                    // 3
    EASP_Largest,                   // 4
    EASP_FootStomp,                 // 5
    EASP_MAX                        // 6
};

var() byte mShakeType;
var export editinline array mPresets;

simulated event Notify(@NULL Owner, @NULL SkelComponent)
{
    Class'TurokRadialParametricShake'.static.BroadcastRadialShake(Owner, mPresets[int(mShakeType)]);
    //return;    
}

defaultproperties
{
    mPresets=/* Array type was not detected. */
}