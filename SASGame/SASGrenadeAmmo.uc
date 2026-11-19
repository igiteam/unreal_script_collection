//=============================================================================
// SASGrenadeAmmo.uc
//
// Abstract base class for ammunition used by hand-grenade weapons.
//=============================================================================

class SASGrenadeAmmo extends SASAmmo
	abstract;

//------------------------------------------------------------------------------
//
//
replication
{
	reliable if ( Role < ROLE_Authority )
		ServerSpawnGrenade;			// ensure clients have access to server spawned grenades
}

//-----------------------------------------------------------------------------
// Functions
//

//-----------------------------------------------------------------------------
// SpawnGrenade
//
simulated function SpawnGrenade( 
	SASGrenadeWeapon	aGrenadeWeapon, 
	Vector				aStart,
	optional bool		abDrop,
	optional bool		abPinPulled )
{
	ServerSpawnGrenade( aGrenadeWeapon, aStart, abDrop, abPinPulled );
}

//------------------------------------------------------------------------------
// ServerSpawnGrenade
//
// spawned server-side as thrown
function ServerSpawnGrenade( 
	SASGrenadeWeapon aGrenadeWeapon, 
	Vector			aStart,
	bool			abDrop,
	bool			abPinPulled )
{
	local SASGrenadeProjectile grenade;
	local Actor		hitActor;
	local Vector	traceStart,
					hitNormal,
					hitLocation;
	local Rotator	eyeRot;
	local Actor		camera;

	if ((ProjectileClass == None) || (class<SASGrenadeProjectile>(ProjectileClass) == None))
	{
		Warn("Projectile class is not an SASGrenadeProjectile type. No grenade spawned.");
	}

	// Check spawn position is OK - hand not intersecting geometry. If it
	// is then find point closer to instigator to spawn it.
	if ( Instigator.Controller != None && Instigator.Controller.mType == CONTROLLER_Player )
	{
		SASPlayerController( Instigator.Controller ).PlayerCalcView( camera, traceStart, eyeRot );
	}
	else
	{
		traceStart = Instigator.Location + Instigator.EyePosition();
	}
	hitActor = Trace(
					hitLocation,
					hitNormal,
					aStart,
					traceStart,
					true,
					vect(1,1,1),
					,
					,
					,
					,
					true );
	if ( hitActor != None )
	{
		aStart = hitLocation - (Normal(hitLocation-traceStart) * 2.0);
	}

	grenade = SASGrenadeProjectile( Spawn( ProjectileClass, aGrenadeWeapon,, aStart ) );

	if ( grenade != None )
	{
		if ( !abDrop )
		{
			grenade.Throw();						// impart velocity
		}
		else
		{
			grenade.Drop( abPinPulled );
		}
		grenade.SetTimer ( grenade.mTimeToExplode, false );
	}
}

//------------------------------------------------------------------------------
// ClientSpawnGrenade
//
// locally (client-side) held grenade - show and hide as needed!
//::simulated function SASGrenadeProjectile ClientSpawnGrenade ( SASGrenadeWeapon grenadeWeapon )
//::{
//::	local SASGrenadeProjectile grenade;
//::
//::	grenade = None;
//::
//::	if ((ProjectileClass == None) || (class<SASGrenadeProjectile>(ProjectileClass) == None))
//::	{
//::		warn("Projectile class is not an SASGrenadeProjectile type. No grenade spawned.");
//::	}
//:://	else if ( ( Pawn ( Owner ).IsLocallyControlled () ) || ( Role < ROLE_Authority ) )
//:://	{
//::		grenade = SASGrenadeProjectile ( Spawn ( ProjectileClass, grenadeWeapon ) );
//:://	}
//::
//::	return grenade;
//::}

//-----------------------------------------------------------------------------
// Default properties
//

// Decompiled with UE Explorer.
defaultproperties
{
    Penetration=0
    bTossed=true
    bInstantHit=false
    bSplashDamage=true
}