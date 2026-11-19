class TurokUVAnimComponent extends TurokInteractiveComponent
    native
    editinlinenew
    hidecategories(Object)
    autoexpandcategories(Collision,Rendering,Lighting);

var() float mAmplitudeScale;
var() float mFrequencyScale;
var() float mOverrideDurationScale;
var() bool mEnableUVAnim;
var() bool mOverrideAllowed;
var bool mOverrideEnabled;
var float mPhase;
var float mDefaultAmplitude;
var float mDefaultFrequency;
var float mOverrideAmplitude;
var float mOverrideFrequency;
var float mOverrideElapsedTime;
var float mOverrideDuration;
var array mUVAnimMaterials;

// Export UTurokUVAnimComponent::execGetNumMaterials(FFrame&, void* const)
native function int GetNumMaterials();

// Export UTurokUVAnimComponent::execOverride(FFrame&, void* const)
native function Override(float Amplitude, float Frequency, float Duration);

// Export UTurokUVAnimComponent::execGetWindDefaults(FFrame&, void* const)
native function GetWindDefaults();

// Export UTurokUVAnimComponent::execInitComponentRBPhys(FFrame&, void* const)
native function InitComponentRBPhys();

// Export UTurokUVAnimComponent::execTermComponentRBPhys(FFrame&, void* const)
native function TermComponentRBPhys();

// Export UTurokUVAnimComponent::execUpdateTransform(FFrame&, void* const)
native function UpdateTransform();

// Export UTurokUVAnimComponent::execInit(FFrame&, void* const)
native function Init();

// Export UTurokUVAnimComponent::execFinishInit(FFrame&, void* const)
native function bool FinishInit();

defaultproperties
{
    mAmplitudeScale=1.0000000
    mFrequencyScale=1.0000000
    mOverrideDurationScale=1.0000000
    mEnableUVAnim=true
    mOverrideAllowed=true
}