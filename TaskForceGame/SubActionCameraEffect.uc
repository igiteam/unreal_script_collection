class SubActionCameraEffect extends MatSubAction
	native
	noexport
	collapsecategories;

var() editinline CameraEffect	CameraEffect;
var() float						StartAlpha,
								EndAlpha;
var() bool						DisableAfterDuration;


// Decompiled with UE Explorer.
defaultproperties
{
    EndAlpha=1.0000000
    DisableAfterDuration=true
    Icon=Texture'SubActionFade'
    Desc="Camera effect"
}