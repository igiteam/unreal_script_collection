//=============================================================================
// ACTION_GunLightOn.uc
//
// Script action to turn on the torch carried by an actor.
//=============================================================================

class ACTION_GunLightOn extends SASScriptAction;

//-----------------------------------------------------------------------------
// Member Vars

var(Action) name				mActorTag;
var(Action) bool				mOn;			// on or off
var(Action) bool				m1stPerson;		// true = 1st person torch, false = 3rd person torch
var SASPawn						mSASPawn;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Init
//
function Init(
	SASScriptedSequence	aScript )
{
	Super.Init( aScript );

	if ( mSASPawn == None )
	{
		GetActor( false );
	}
}


///////////////////////////////////////////////////////////////////////////////
// GetDamageActor
//
function GetActor(
	bool	abRequireNow )
{
	local SASGameInfo	gi;

	// Get reference to actor to damage
	gi = SASGameInfo( mOwnerScript.Level.Game );
	if ( gi != None )
	{
		foreach gi.AllSASPawns ( class'SASPawn', mSASPawn, mActorTag )
		{
			break;
		}
	}

	if ( (mSASPawn == None) && abRequireNow )
	{
		Warn( "ACTION_GunLightOn: Could not find actor for "$self$" in "$mOwnerScript );
	}
}


///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local SASWeapon				tWeapon;
//	local SASWeaponAttachment	tWpnAtt;

	Log("ACTION_GunLightOn: DoAction");

	if ( mSASPawn == None )
	{
		GetActor( true );
	}

	if ( mSASPawn != None )
	{
		tWeapon = SASWeapon(mSASPawn.Weapon);
		if(tWeapon != None)
		{
			mSASPawn.SetGunLight(mOn);
		}
		else
		{
			Warn( "ACTION_GunLightOn: actor "$mSASPawn$" has no weapon, for script "$self$" in "$mOwnerScript );
		}
	}
	return true;
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mOn;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mOn=true
    mActionString="Actor Torch On"
}