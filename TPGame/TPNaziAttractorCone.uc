//This is TOTALLY jacked from KryllRepuslorCone
class TPNaziAttractorCone extends TPNaziAttractor
	native;

/** Repulsor is spherical, this is the sphere radius. */
var() float		Angle;

/** Preview component for editor. */
var	private DrawConeComponent		ConeRenderComponent;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native simulated function SetRadius(float NewRadius);

simulated function SetAngle(float NewAngle)
{
	Angle = NewAngle;
	ConeRenderComponent.ConeAngle = NewAngle;
}

/** Returns true if TestLoc is inside the repulsor, false otherwise. */
native simulated function bool Encompasses(vector TestLoc);


