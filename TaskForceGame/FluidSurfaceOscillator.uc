#exec Texture Import File=Textures\S_FluidSurfOsc.dds Name=S_FluidSurfOsc Mips=Off MASKED=1

//=============================================================================
// FluidSurfaceOscillator.
//=============================================================================
class FluidSurfaceOscillator extends Actor
	native
	placeable;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

// FluidSurface to oscillate
var() edfindable FluidSurfaceInfo	FluidInfo;
var() float							Frequency;
var() byte							Phase;
var() float							Strength;
var() float							Radius;

var transient const float			OscTime;


// Decompiled with UE Explorer.
defaultproperties
{
    Frequency=1.0000000
    Strength=10.0000000
    bHidden=true
    Texture=Texture'S_FluidSurfOsc'
}