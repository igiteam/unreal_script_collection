
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */

class GSM_MantleUpLowCover extends GSM_MantleUpBase
	config(TGPawn);

protected function bool InternalCanDoSpecialMove()
{
	if( PawnOwner.CoverType != CT_MidLevel || (PawnOwner.MyTGWeapon != None && PawnOwner.MyTGWeapon.WeaponType == WT_Heavy) )
	{
		return FALSE;
	}

	return Super.InternalCanDoSpecialMove();
}

