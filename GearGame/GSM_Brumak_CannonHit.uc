
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Brumak_CannonHit extends GSM_Brumak_BasePlaySingleAnim;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted( bForced, PrevMove );

	// Turn off main gun controller. This is the destroy animation.
	TurnOffMainGunController();
}

final function TurnOffMainGunController()
{
	if( Brumak != None && Brumak.MainGunAimController1.StrengthTarget != 0.f )
	{
		Brumak.MainGunAimController1.SetSkelControlStrength(0.f, BlendInTime);
		Brumak.MainGunAimController2.SetSkelControlStrength(0.f, BlendInTime);
	}
}

defaultproperties
{
	bLockPawnRotation=TRUE

	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="big_cannon_hit_short")))
	BlendInTime=0.33f
	BlendOutTime=0.67f
}