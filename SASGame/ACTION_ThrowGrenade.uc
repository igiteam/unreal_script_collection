//=============================================================================
// ACTION_ThrowGrenade.uc
//
// Script action to make controlled pawn throw a grenade at a specified 
// SASGrenadePoint target.
//=============================================================================

class ACTION_ThrowGrenade extends SASLatentScriptAction;


//-----------------------------------------------------------------------------
// Enums

enum EThrowGrenadeType
{
	THROW_Explosive,
	THROW_Stun,
	THROW_Gas,
	THROW_Smoke,
	THROW_Molotov
};

//-----------------------------------------------------------------------------
// Member Vars

var(Action)	EThrowGrenadeType	meGrenadeType;				
var(Action)	name				mGrenadePointTag;

var SASGrenadePoint				mTgtGrenadePoint;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Init
//
function Init(
	SASScriptedSequence	aScript )
{
	Super.Init ( aScript );

	if ( mGrenadePointTag != 'None' )
	{
		foreach mOwnerScript.AllActors( Class'SASGrenadePoint', mTgtGrenadePoint, mGrenadePointTag )
		{
			break;
		}
	}

	if ( mTgtGrenadePoint == None )
	{
		LogHuman( "ACTION_ThrowGrenade: No target grenade point found for "$self$" in "$mOwnerScript );
	}
}


///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local SASPawn			scriptedPawn;
	local EGrenadeCategory	category;

	if ( (aInterface.mAIController != None) && (mTgtGrenadePoint != None) )
	{
		switch ( meGrenadeType )
		{
		case THROW_Explosive:
			category = GRENADECAT_Explosive;
			break;

		case THROW_Stun:
			category = GRENADECAT_Stun;
			break;

		case THROW_Gas:
			category = GRENADECAT_Gas;
			break;

		case THROW_Smoke:
			category = GRENADECAT_Smoke;
			break;

		case THROW_Molotov:
			category = GRENADECAT_Molotov;
			break;

		default:
			category = GRENADECAT_None;
		}

		if ( category != GRENADECAT_None )
		{
			scriptedPawn = SASPawn( aInterface.mAIController.Pawn );
			if ( (scriptedPawn != None) 
				&& (scriptedPawn.GetWeaponOfCategory( WPNCAT_Grenade, category ) != None) )
			{
				// Seting up grenade data signals to controller that it is doing a grenade throw.
				aInterface.mAIController.mGrenadePoint = mTgtGrenadePoint;
				aInterface.mAIController.mThrowGrenadeType = category;

				return Super.DoAction( aInterface );
			}
		}
	}

	return true;
}


///////////////////////////////////////////////////////////////////////////////
// CompleteOnEndFiring
//
function bool CompleteOnEndFiring()
{
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// CanDoAvoidance
//
function bool CanDoAvoidance()
{
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// ShouldSkipOnScriptResume
//
function bool ShouldSkipOnScriptResume()
{
	return true;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Throw grenade"
}