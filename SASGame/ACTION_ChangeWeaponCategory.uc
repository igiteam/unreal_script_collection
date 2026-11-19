//=============================================================================
// ACTION_ChangeWeaponCategory.uc
//
// Script action to change to weapon of specified category for the pawn 
// of the controller which is running the script.
//=============================================================================

class ACTION_ChangeWeaponCategory extends SASScriptAction;

//-----------------------------------------------------------------------------
// Enums

enum EWeaponChange
{
	WPNCHANGE_Primary,
	WPNCHANGE_Secondary,
	WPNCHANGE_Knife,
	WPNCHANGE_Grenade
};

enum EGrenadeChange 
{
	GRENADECHANGE_Explosive,
	GRENADECHANGE_Stun,
	GRENADECHANGE_Smoke,
	GRENADECHANGE_Gas,
	GRENADECHANGE_Molotov
};

//-----------------------------------------------------------------------------
// Member Vars

var(Action) EWeaponChange		mWeaponCategory;
var(Action) EGrenadeChange		mGrenadeSubCat;


//-----------------------------------------------------------------------------
// Functions

///////////////////////////////////////////////////////////////////////////////
// DoAction
//
function bool DoAction(
	SASScriptInterface	aInterface )
{
	local EWeaponCategory	wpnCat;
	local EGrenadeCategory	grenadeCat;

	if ( aInterface.mAIController == None )
	{
		return true;
	}

	if ( (aInterface.mAIController.Pawn != None) 
		&& (SASPawn( aInterface.mAIController.Pawn ) != None) )
	{
		switch ( mWeaponCategory )
		{
		case WPNCHANGE_Primary:
			wpnCat = WPNCAT_Primary;
			break;

		case WPNCHANGE_Secondary:
			wpnCat = WPNCAT_Secondary;
			break;

		case WPNCHANGE_Knife:
			wpnCat = WPNCAT_Knife;
			break;

		case WPNCHANGE_Grenade:
			wpnCat = WPNCAT_Grenade;

			switch ( mGrenadeSubCat )
			{
			case GRENADECHANGE_Explosive:
				grenadeCat = GRENADECAT_Explosive;
				break;

			case GRENADECHANGE_Stun:
				grenadeCat = GRENADECAT_Stun;
				break;

			case GRENADECHANGE_Smoke:
				grenadeCat = GRENADECAT_Smoke;
				break;

			case GRENADECHANGE_Gas:
				grenadeCat = GRENADECAT_Gas;
				break;

			case GRENADECHANGE_Molotov:
				grenadeCat = GRENADECAT_Molotov;
				break;
			}
			break;
		}

		SASPawn( aInterface.mAIController.Pawn ).SelectWeapon( wpnCat, grenadeCat );
	}

	return true;	
}


///////////////////////////////////////////////////////////////////////////////
// GetActionString
//
function string GetActionString()
{
	return mActionString@mWeaponCategory@mGrenadeSubCat;
}


//-----------------------------------------------------------------------------
// Default Properties


// Decompiled with UE Explorer.
defaultproperties
{
    mActionString="Change Weapon"
}