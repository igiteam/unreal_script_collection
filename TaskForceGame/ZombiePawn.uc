class ZombiePawn extends Pawn
	native;

var(Faction) EFaction Faction;		// Pawn faction

var bool bReticuleHighlight;		// Should the reticule highlight when I'm targeted?
var bool bEasyAiming;				// whether or not to slow down the yaw of someone aiming at me.
var bool bDemiGod;					// only hurt by player characters
var bool bInvincible;				// takes no damage

var name TargetedName;				// Visible name of pawn

// TODO - REMOVE ME - LEGACY SHIT
var bool bIsSpecForcePawn;
var bool bIsSpecForceEnemyPawn;
var bool bIsSpecForcePlayerPawn;

// overridden in sub classes
simulated event EFaction GetFaction ( )
{
	return Faction;
}

function ZombiePawn GetZombiePawn ( )
{
	return Self;
}

// helper function
function BasicHUD GetHUD ( )
{ 
	return none;
}

// ????
simulated function Tick ( float DeltaTime )
{
	// assume dead if bTearOff - for remote clients unfff unfff
    if ( bTearOff )
    {
        if ( !bPlayedDeath )
		{
            PlayDying ( HitDamageType, TakeHitLocation );
		}
        return;
    }
}


// Use me to determine the material type that this pawn is standing on!!!!
simulated function EMaterialTypes GetFloorMaterial ( optional vector OffsetFromCenter )
{
	local vector			HitLocation;	// out
	local vector			HitNormal;		// out
	local vector			TraceStart, TraceEnd;
	local material			mStandingOn;
	local EMaterialTypes	RetVal;
	local Actor				TracedHitActor;

	// initialize to none
	RetVal = MATERIAL_None;

	// if we're not on a ladder
	if ( OnLadder == None )
	{
		// set up start and end location
		TraceStart = Location + OffsetFromCenter;
		TraceEnd = TraceStart;
		TraceEnd.Z -= 2 * CollisionHeight;

		// perform the trace
		TracedHitActor = Trace ( HitLocation, HitNormal, TraceEnd, TraceStart,,, mStandingOn );

		// return the material type
		if ( mStandingOn != None )
		{
			RetVal = mStandingOn.MaterialType;
		}
	}
	else
	{
		// get it from the ladder volume
		RetVal = OnLadder.LadderMaterialType;
	}

	// return the material type
	return RetVal;
}


// Decompiled with UE Explorer.
defaultproperties
{
    Faction=1
    bReticuleHighlight=true
    bEasyAiming=true
    bCanClimbLadders=true
}