class FocusTexMaterial extends RenderedMaterial
	editinlinenew
	native;
/*
var() editinlineuse Material Diffuse;
var() editinlineuse Material Opacity;

var() editinlineuse Material Specular;
var() editinlineuse Material SpecularityMask;

var() editinlineuse Material SelfIllumination;
var() editinlineuse Material SelfIlluminationMask;

var() editinlineuse Material Detail;


var() enum EOutputBlending
{
	OB_Normal,
	OB_Masked,
	OB_Modulate,
	OB_Translucent,
	OB_Invisible,
	OB_Brighten,
	OB_Darken,
} OutputBlending;

var() bool TwoSided;
var() bool Wireframe;
var   bool ModulateStaticLighting2X;
var() bool PerformLightingOnSpecularPass;
*/

var() editinlineuse Material BlurTex;
var() editinlineuse Material ClearTex;
var() editinlineuse Material RangeTex;

function Trigger( Actor Other, Actor EventInstigator )
{
}

