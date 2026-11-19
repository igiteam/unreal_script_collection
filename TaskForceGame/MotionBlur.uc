class MotionBlur extends CameraEffect
	native
	noexport
	editinlinenew
	collapsecategories;

var() byte		BlurAlpha;

var const int	RenderTargets;
var const float	LastFrameTime;


// Decompiled with UE Explorer.
defaultproperties
{
    BlurAlpha=128
}