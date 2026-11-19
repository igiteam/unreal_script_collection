class OLAnimNotify_OverrideCameraParams extends AnimNotify
	native(Anim);

var() bool bResetToDefault;

var() bool bLocalSpacePlayerControl;

var() bool bMinYaw;
var() bool bMaxYaw;
var() bool bMinPitchWS;
var() bool bMaxPitchWS;
var() bool bMinPitchCS;
var() bool bMaxPitchCS;

var() float MinYaw;
var() float MaxYaw;
var() float MinPitchWS;
var() float MaxPitchWS;
var() float MinPitchCS;
var() float MaxPitchCS;

cpptext
{
	virtual void Notify( class UAnimNodeSequence* NodeSeq );
	virtual FString GetEditorComment() { return TEXT("CameraParams"); }
}

defaultproperties
{
	bMinYaw=true
	bMaxYaw=true
	bMinPitchCS=true
	bMaxPitchCS=true
}