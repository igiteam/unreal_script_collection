/**
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class AICmd_ScriptedThrowGrenade extends AICommand;

/** target for throw */
var Actor ScriptedTarget;

var Actor OldFireTarget;
var Actor OldFocus;
var transient float OldThrowTime;
var Weapon OldForcedWeapon;
var GearAI_Cover GAIC;
var CoverInfo OldCover;

static function bool InitCommandUserActor(GameAIController AI, Actor UserActor)
{
	local AICmd_ScriptedThrowGrenade Cmd;

	if (AI != None)
	{
		Cmd = new(GearAI(AI)) Default.Class;
		if (Cmd != None)
		{
			Cmd.ScriptedTarget = UserActor;
			AI.PushCommand(Cmd);
			return TRUE;
		}
	}
}

function Pushed()
{
	local Weapon GrenadeWeap;

	Super.Pushed();

	GAIC = GearAI_Cover(Outer);

	GrenadeWeap = Weapon(Pawn.InvManager.FindInventoryType(class'GearWeap_GrenadeBase', true));
	if (GrenadeWeap == None || !GrenadeWeap.HasAnyAmmo())
	{
		Status = 'Failed';
		PopCommand(self);
	}
	else
	{
		OldForcedWeapon = ForcedWeapon;
		ForcedWeapon = GrenadeWeap;
		OldCover.Link = MyGearPawn.CurrentLink;
		OldCover.SlotIdx = MyGearPawn.CurrentSlotIdx;

		SelectWeapon();

		if( GAIC != none && MyGearPawn.IsInCover() )
		{
			GAIC.InvalidateCover(false,true);	
		}
	}

}

function Popped()
{
	Super.Popped();
	
	FireTarget = OldFireTarget;
	Focus = OldFocus;
	ForcedWeapon = OldForcedWeapon;
	//`log(self@GetFuncName()@outer);
	ClearLatentAction(class'SeqAct_AIThrowGrenade', Status != 'Success');
}

function rotator GetAdjustedAimFor(Weapon W, vector StartFireLoc)
{
	FireTarget = ScriptedTarget;
	return Super.GetAdjustedAimFor(W, StartFireLoc);
}

auto state ThrowingGrenade
{
Begin:
	// save off old settings so we can restore it once we're done
	OldFireTarget = FireTarget;
	OldFocus = Focus;

	FireTarget = ScriptedTarget;	
	Focus = FireTarget;

	StopFiring();
	while (IsSwitchingWeapons())
	{
		Sleep(0.25);
	}

	`AILog("Done switching weapons");

	bAllowedToFireWeapon = true;
	OldThrowTime=LastGrenadeTime;
	StartFiring();
	`AILog("Called startfiring");
	// wait until a grenade is thrown
	do
	{
		Sleep(0.25);
	} until (LastGrenadeTime!=OldThrowTime);

	`AILog("done");

	if( OldCover.Link != none && GAIC != none )
	{
		`AILog("Re-Entering cover");
		GAIC.SetCoverGoal(OldCover,FALSE,FALSE);
	}
	Status = 'Success';
	PopCommand(self);
}

defaultproperties
{
	bAllowedToFireWeapon=false
}
