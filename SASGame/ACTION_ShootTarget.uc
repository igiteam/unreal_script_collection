//=============================================================================
// ACTION_ShootTarget.uc
//
// Script action to make controlled pawn shoot at its current target.
//=============================================================================

class ACTION_ShootTarget extends SASScriptAction;


//-----------------------------------------------------------------------------
// Enums

// Weapon fire modes. This enum mirrors the FIREMODE_xxx const values in the  
// SASWeapon class. It is required as those values cannot be accessed from
// this class.
enum eFireMode
{
	FM_Single,
	FM_Burst,
	FM_Auto
};


//-----------------------------------------------------------------------------
// Member Vars

var(Action) eFireMode	mFireMode;		// Firemode to shoot with
var(Action) int			mNumShots;		// Num shots to fire


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

	switch ( mFireMode )
	{
	case FM_Single:
		aInterface.mAIController.SetWeaponFireMode( 'FIREMODE_Single' );
		break;

	case FM_Burst:
		aInterface.mAIController.SetWeaponFireMode( 'FIREMODE_Burst' );
		break;

	case FM_Auto:
		aInterface.mAIController.SetWeaponFireMode( 'FIREMODE_Auto' );
		break;
	}

	aInterface.mbScriptFiring			= true;
	aInterface.mScriptFiringNumShots	= mNumShots;

	return true;	
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Shoot Target"
}