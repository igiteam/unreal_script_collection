//=============================================================================
// ACTION_TakeDamage.uc
//
// Script action to apply damage to the controlled pawn.
//=============================================================================

class ACTION_TakeDamage extends SASScriptAction;


//-----------------------------------------------------------------------------
// Member Vars

var(Action) int					mDamageAmount;		// Amount of damage
var(Action) class<DamageType>	mDamageType;		// Damage type class


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	if ( aInterface.mAIController == None )
	{
		return true;
	}
		
	if ( aInterface.mAIController.Pawn != None )
	{
		aInterface.mAIController.Pawn.TakeDamage(
			mDamageAmount,
			aInterface.mAIController.Pawn,
			aInterface.mAIController.Pawn.Location,
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
    mActionString="Take Damage"
}