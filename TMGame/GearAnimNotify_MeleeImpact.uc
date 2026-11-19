
/**
 * Copyright 1998-2008 Epic Games, Inc. All Rights Reserved.
 */
class GearAnimNotify_MeleeImpact extends AnimNotify_Scripted;

/** Indicates if it's the begining or the end of the melee impact */
var() bool	bImpactStart;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local Pawn		P;
	local TGWeapon	Weap;

	P = Pawn(Owner);
	if( P != None && P.Weapon != None )
	{
		Weap = TGWeapon(P.Weapon);

		if( Weap != None )
		{
			Weap.MeleeImpactNotify(Self);
		}
	}
}
