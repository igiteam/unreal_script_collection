class SASEvacuationVolume extends Volume
	native;

// A header file named the same as the class is implicitly included as soon as it exists... hence removed the cpptext here.

var() edfindable array<SASEvacuationPoint>	mEvacPoints;	// Evac points to run to.
var	SASCoverPoint							mCoverPoints;	// Hostage CPs in evac volume to use when no evac points defines.



// Decompiled with UE Explorer.
defaultproperties
{
    BrushColor=(R=180,G=180,B=180,A=255)
    bColored=true
}