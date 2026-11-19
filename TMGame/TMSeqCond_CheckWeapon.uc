/**
 * Copyright 1998-2009 Epic Games, Inc. All Rights Reserved.
 */

class TMSeqCond_CheckWeapon extends SequenceCondition;

var Actor Target;
var() class<TMWeapon> TestForWeaponClass;

event Activated()
{
	local TMPawn P;
	local TMPlayerController PC;
	local bool Results;

	PC = TMPlayerController(Target);
	if ( PC != none )
	{
		P = TMPawn(PC.Pawn);
		if ( P != none  )
		{
			Results = P.Weapon.Class == TestForWeaponClass;
		}
	}

	OutputLinks[ Results ? 0 : 1].bHasImpulse = true;
}



