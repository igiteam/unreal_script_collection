
/**
* Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
*/
class NanoAnimNotify_MeleeImpact extends AnimNotify_Scripted;

/** Indicates if it's the begining or the end of the melee impact */
var() bool	bImpactStart;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
	local Pawn		P;
	local NanoWeaponBase	Weap;

	P = Pawn(Owner);
	if( P != None && P.Weapon != None )
	{
		Weap = NanoWeaponBase(P.Weapon);

		if( Weap != None )
		{
			Weap.MeleeImpactNotify(Self);
		}
	}
}