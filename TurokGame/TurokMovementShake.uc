class TurokMovementShake extends CameraModifier
    native
    config(Game);

var config float mRollDamping;
var config float mPitchDamping;
var config float mStrafeDamping;
var config float mTransAmplitude;
var config float mPitchPhaseOffset;
var config float mRollDampingCrouched;
var config float mPitchDampingCrouched;
var config float mStrafeDampingCrouched;
var config float mTransAmplitudeCrouched;
var transient float mRoll;
var transient float mPitch;
var transient float mTrans;

// Export UTurokMovementShake::execModifyCamera(FFrame&, void* const)
native function bool ModifyCamera(@NULL Camera, float DeltaTime, out @NULL OutPOV);
