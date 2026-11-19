//=============================================================================
// ACTION_KillPawn.uc
//
// Script action to kill the pawn possessed by the controller running the 
// script. Pawn will switch to its killed behaviour. A hit impulse can
// optionally be provided to initilise the ragdoll dynamics.
//=============================================================================

class ACTION_KillPawn extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action) class<DamageType>		mDamageType;		// Type of damage to apply on death
var(Action) name					mImpulseBoneName;	// Optional bone to apply hit impulse
var(Action) Rotator					mImpulseDir;		// Hit impulse direction
var(Action) float					mImpulseMag;		// Hit impulse size


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local Pawn		tPawn;
	local Coords	hitCoords;
	local Rotator	impulseRotation;

	if ( aInterface.mAIController == None )
	{
		return true;
	}

	if ( aInterface.mAIController.Pawn != None )
	{
		tPawn = aInterface.mAIController.Pawn;

		if ( mImpulseBoneName != 'None' )
		{
			// Setup initial hit params
			hitCoords = aInterface.mAIController.Pawn.GetBoneCoords( mImpulseBoneName );

			impulseRotation = tPawn.Rotation + mImpulseDir;
			tPawn.TearOffAcceleration = Vector( impulseRotation ) * mImpulseMag;
		}
		else
		{
			hitCoords.Origin = tPawn.Location;
		}

		tPawn.Died( None, mDamageType, hitCoords.Origin );
	}

	return true;	
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mDamageType@mImpulseBoneName;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Kill Pawn"
}