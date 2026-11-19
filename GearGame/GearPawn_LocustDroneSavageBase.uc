
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearPawn_LocustDroneSavageBase extends GearPawn_LocustDroneBase
	abstract
	config(Pawn);

/** Attempt to play ROAR animation. No Guarantee it's going to succeed. 
 *  Netmode: Server. Replicated RoarCount var, will trigger the client side version. */
function TryToRoar()
{
	// Limit the number of times Savage Drones ROAR globally.
	if( `TimeSince(GearGRI(WorldInfo.GRI).LastSavageDroneROAR) < 4.f )
	{
		return;
	}

	// Must not be doing a special move, or be in cover.
	if( IsDoingASpecialMove() || CoverType != CT_None || bDoingMeleeAttack || IsFiring() || IsReloadingWeapon() )
	{
		return;
	}

	if( FullBodyNode != None && !FullBodyNode.bIsPlayingCustomAnim )
	{
		ServerDoSpecialMove(GSM_SavageDrone_ROAR);
	}
}

simulated function vector GetWeaponAimIKPositionFix()
{
	return Super.GetWeaponAimIKPositionFix() + vect(0,4,-2);
}


/** Overloaded to remove flappy bits */
simulated function TakenHostageNotify()
{
	Super.TakenHostageNotify();

	// Hide the headband
	if (Mesh != None)
	{
		Mesh.HideBoneByName('HeadBand_1', PBO_Term);
	}
}


defaultproperties
{
	SpecialMoveClasses(GSM_SavageDrone_EmergeFromUnderground)=class'GSM_SavageDrone_EmergeFromUnderground'
	SpecialMoveClasses(GSM_SavageDrone_ROAR)=class'GSM_SavageDrone_ROAR'
}
