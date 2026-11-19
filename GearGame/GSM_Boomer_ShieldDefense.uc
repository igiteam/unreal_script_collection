
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Boomer_ShieldDefense extends GearSpecialMove;

/** Cached pointed to AnimNodeBlend, set by boomer. */
var transient AnimNodeBlend	CoverBlend;

/**
 * Can this special move override InMove if it is currently playing?
 */
function bool CanOverrideSpecialMove(ESpecialMove InMove)
{
	return (InMove == SM_RoadieRun);
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced,PrevMove);

	// Force Boomer into ducking stance.
	if( CoverBlend != None )
	{
		CoverBlend.SetBlendTarget(1.f, 0.33f);
	}

	if( PawnOwner.EquippedShield != None )
	{
		PawnOwner.EquippedShield.Expand();
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	// Boomer can get up now.
	if( CoverBlend != None )
	{
		CoverBlend.SetBlendTarget(0.f, 1.f);
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);

	if( PawnOwner.EquippedShield != None )
	{
		PawnOwner.EquippedShield.Retract();
	}
}

defaultproperties
{
	bCanFireWeapon=FALSE
}


