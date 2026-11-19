/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class NanoSkill_Melee extends NanoSkill
	config(Pawn);

simulated function bool GetSwordConstraints( out int MaxSuperAttack, out float DamageScale )
{
    DamageScale = 1.f;
	switch (SkillLevel)
	{
	case 0:
		MaxSuperAttack = 0;
		return FALSE;
	case 1:
		MaxSuperAttack = 0;
		return TRUE;
	case 2:
		MaxSuperAttack = 1;
		return TRUE;
	case 3:
		MaxSuperAttack = 2;
		return TRUE;
	case 4:
	default:
		MaxSuperAttack = 3;
		return TRUE;
	}
}

defaultproperties
{
	SkillType=NS_Melee

	SkillIconOrigin=(X=128)
	SkillIconSize=(X=64,Y=64)
}

