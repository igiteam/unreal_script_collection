//=============================================================================
// SASBulletHitWithGravity
// Emitter effects for bullet hitting stuff that falls due to gravity
//=============================================================================

class SASBulletHitWithGravity extends SASBulletHit
	abstract;

var float AccelerationDueToGravity;
var float VertVel; // avoiding velocity member like some kind of jerk.

simulated function Tick( float Delta )
{
	local vector new_location;

	VertVel += AccelerationDueToGravity * Delta;
	
	new_location = Location;
	new_location.Z -= VertVel;
	
	SetLocation(new_location);
}

//-----------------------------------------------------------------------------
// Default properties


// Decompiled with UE Explorer.
defaultproperties
{
    AccelerationDueToGravity=2.0000000
}