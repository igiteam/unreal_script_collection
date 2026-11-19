//=============================================================================
// ACTION_ChangeWeapon.uc
//
// Script action to change weapon on the pawn of the controller which is
// running the script.
//=============================================================================

class ACTION_ChangeWeapon extends SASScriptAction;

//-----------------------------------------------------------------------------
// Member Vars

var(Action) class<Weapon>	mNewWeapon;		// Class of weapon to change to


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

	// Switch to weapon only if it is in pawns inventory
	aInterface.mAIController.Pawn.PendingWeapon 
		= Weapon( aInterface.mAIController.Pawn.FindInventoryType( mNewWeapon ) );
	aInterface.mAIController.Pawn.ChangedWeapon();

	return true;	
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString ()
{
	return mActionString@mNewWeapon;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Change Weapon"
}