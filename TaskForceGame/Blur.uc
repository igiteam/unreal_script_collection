class Blur extends HardwareCameraEffect
	native
	noexport
	editinlinenew
	collapsecategories;

//var() byte		BlurAlpha;
//
//var const int	RenderTargets[2];
//var const float	LastFrameTime;

var const int		ZBufferTex;
var const int		BlurTex;
var const int		BlurTex2;
var HardwareShader	BlurShader;
var HardwareShader	DepthDbgShader;

var() float Offset;
var() float Range;
var() Actor FocusObject;
var int TexChoice;

function IncTexChoice()
{
	//This be the law:
	//0 - none
	//1 - BlurTex
	//2 - BlurTex2
	//3 - ZBufferTexture
	//4 - Full Effect
	TexChoice = (TexChoice+1)%5;
}


// Decompiled with UE Explorer.
defaultproperties
{
    BlurShader=HardwareShader'HardwareShaders.Blur.Blur'
    DepthDbgShader=HardwareShader'HardwareShaders.DepthDBG.DepthDBG'
    offset=0.8000000
    Range=1.0000000
    TexChoice=4
    Shader=HardwareShader'HardwareShaders.Focus.Focus'
}