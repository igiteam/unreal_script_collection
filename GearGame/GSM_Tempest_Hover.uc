/**
 * Play a tempest hover animation
 * 
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Tempest_Hover extends GSM_BasePlaySingleAnim;

var GearPawn.BodyStance BS_Hover_1;
var GearPawn.BodyStance BS_Hover_2;
var GearPawn.BodyStance BS_Hover_3;

function SetupAnimation()
{
	local int RandomNumber;

	RandomNumber = Rand(3);
	switch (RandomNumber)
	{
		case 0:
			BS_Animation = BS_Hover_1;
			break;
		case 1:
			BS_Animation = BS_Hover_2;
			break;
		case 2:
			BS_Animation = BS_Hover_3;
			break;
	}
}

/** Overwrite so we can open the mouth **/
function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearPawn_LocustTempestBase Tempest;

	SetupAnimation();

	Tempest = GearPawn_LocustTempestBase(PawnOwner);

	Super.SpecialMoveStarted(bForced, PrevMove);

	Tempest.OpenMouth();
}

/** Overwrite so we can close the mouth **/
function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local GearPawn_LocustTempestBase Tempest;

	Tempest = GearPawn_LocustTempestBase(PawnOwner);
	Tempest.CloseMouth();
	Tempest.ResetIdle();

	Super.SpecialMoveEnded(PrevMove, NextMove);

	Tempest.TriggerEventClass(class'SeqEvt_TempestAnimFinished', Tempest, 3);
}

defaultproperties
{
	BS_Hover_1=(Stance=((Slot=BS_FullBody,AnimName="Hover_Outdoor")))
	BS_Hover_2=(Stance=((Slot=BS_FullBody,AnimName="Hover_Outdoor")))
	BS_Hover_3=(Stance=((Slot=BS_FullBody,AnimName="Hover_Outdoor")))

	// if not, root motion will be still active (root distance) while playing next one
	BlendOutTime=0.f
	bDisableAI=TRUE
}
