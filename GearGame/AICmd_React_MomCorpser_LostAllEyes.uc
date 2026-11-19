/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_React_MomCorpser_LostAllEyes extends AICommand_SpecialMove
	within GearAI_MomCorpser;

/** Last target used for charging */
var TargetPoint LastTargetUsed;

/** Overloaded to go to the special move state */
function Pushed()
{
	Super.Pushed();
	InitChargeLocations();
	Corpser.StopStabAttack();
	Corpser.bIsRampaging = true;
	GotoState('Mad');
}

function DoMadCharge()
{
	local int TargetIdx;

	TargetIdx = Rand(ChargeLocations.Length);
	if (LastTargetUsed == ChargeLocations[TargetIdx])
	{
		TargetIdx = (TargetIdx + 1) % ChargeLocations.Length;
	}
	LastTargetUsed = ChargeLocations[TargetIdx];
	class'AICmd_React_MomCorpser_LostEye'.static.InitLostEyeCommand(Outer, LastTargetUsed.Location, true);
}

state Mad
{
Begin:
	`AILog( "BEGIN TAG"@GetStateName(), 'State' );
	do 
	{
		DoMadCharge();
	}
	until (Pawn.Health <= 0 || ChargeLocations.Length == 0);
	Status = 'Success';
	PopCommand(self);
}

defaultproperties
{
}