//=============================================================================
// ACTION_DamageActor.uc
//
// Script action to damage a specified actor.
//=============================================================================

class ACTION_DamageActor extends SASScriptAction;

//-----------------------------------------------------------------------------
// Member Vars

var(Action) name				mActorTag;		// Tag of actor to damage
var(Action) int					mDamageAmount;	// Amount of damage to apply
var(Action) class<DamageType>	mDamageType;	// Damage type class

var Actor						mDamageActor;	// Reference to actor to damage


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// Init
//
function Init(
	SASScriptedSequence	aScript )
{
	Super.Init( aScript );

	if ( mDamageActor == None )
	{
		GetDamageActor( false );
	}
}


///////////////////////////////////////////////////////////////////////////////
// GetDamageActor
//
function GetDamageActor(
	bool	abRequireNow )
{
	// Get reference to actor to damage
	if ( mActorTag != 'None' )
	{
		foreach mOwnerScript.AllActors( class'Actor', mDamageActor, mActorTag )
		{
			break;
		}
	}

	if ( (mDamageActor == None) && abRequireNow )
	{
		LogHuman( "ACTION_DamageActor: Could not find actor to damage for "$self$" in "$mOwnerScript );
	}
}


///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	if ( mDamageActor == None )
	{
		GetDamageActor( true );
	}

	if ( mDamageActor != None )
	{
		mDamageActor.TakeDamage (
				mDamageAmount,
				None,
				mDamageActor.Location,
				vect(0,0,0),
				mDamageType );
	}

	return true;
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@(string(mDamageType))@mDamageAmount;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mDamageAmount=10
    mActionString="Damage Actor"
}