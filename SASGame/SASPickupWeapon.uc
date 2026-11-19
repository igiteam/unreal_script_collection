////////////////////////////////////////////////////////////////////////////////
// SASPickupWeapon.uc
//
// generic weapon pickup data: override for specific weapon
////////////////////////////////////////////////////////////////////////////////

class SASPickupWeapon extends StaticMeshActor
	abstract;

////////////////////////////////////////////////////////////////////////////////
// variables 
//
var String			mWeaponClassName;
var() float			mRespawnTime;				// would you want to edit this?

////////////////////////////////////////////////////////////////////////////////
// PreBeginPlay 
//
function PreBeginPlay ()
{
	Respawn ();
}

////////////////////////////////////////////////////////////////////////////////
// Respawn
//
function Respawn ()
{
	local SASPlaceablePickup	pickup;
	if ( ( Role == ROLE_Authority ) && ( Level.NetMode != NM_Client ) )
	{
		pickup = Spawn( class'SASGame.SASPlaceablePickup', self,, Location, Rotation );
		if ( pickup == None )
		{
			Warn ( "Unable to spawn pickup from pickup weapon data" @self );
		}
		else
		{
			pickup.SetPhysics( PHYS_None );
			pickup.SetCollision( true, false, false );
			pickup.SetDrawType( DT_StaticMesh );
			pickup.SetStaticMesh( StaticMesh );
		}
	}

	bHidden = true;
}

////////////////////////////////////////////////////////////////////////////////
// DoPickup
//
function DoPickup ()
{
	bHidden = true;

	if ( mRespawnTime > 0 )
	{
		SetTimer ( mRespawnTime, false );
	}
}

////////////////////////////////////////////////////////////////////////////////
// Timer
//
event Timer ()
{
	Respawn ();
}

////////////////////////////////////////////////////////////////////////////////
// defaultproperties 
//

// Decompiled with UE Explorer.
defaultproperties
{
    bStatic=false
    bHidden=true
    bCollideActors=false
    bBlockActors=false
    bBlockZeroExtentTraces=false
}