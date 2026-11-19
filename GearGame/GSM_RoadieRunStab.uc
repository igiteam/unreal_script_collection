
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_RoadieRunStab extends GSM_RoadieRun
	DependsOn(GearPawn)
	native(SpecialMoves);

/* The sound playing while attacking */
var AudioComponent ScreamSound;
var AudioComponent BladeSound;

/** Scream Timing */
var config  float TimeTillScream;
var config  float TimeTillScreamEnd;

//Whether or not the player is currently screaming
var bool bIsScreaming;

/** Time the player has been running */
var float RunTime;

var float LastRunStopTime;

var config float RestTime;

/** Custom roadie run full body animation **/
var()	BodyStance	BS_CustomRoadieRun;

cpptext
{
	virtual void TickSpecialMove(FLOAT DeltaTime);
};


/**
* On server only, possibly save chained move
* @Return TRUE if move could be chained to this one
*/
function bool CanChainMove(ESpecialMove NextMove)
{
	return ( NextMove == SM_BayonetAttack ||  NextMove == SM_BayonetDraw_Leader ||   NextMove == SM_BayonetDraw_Follower || NextMove == SM_MantleDown);
}

protected function bool InternalCanDoSpecialMove()
{
	if (PawnOwner.Health <= 0 && !PawnOwner.IsDBNO())
	{
		// could be waiting to go dbno (bDelayedDBNO on server)
		return false;
	}

	//If youre in a walk volume, no running!
	if (WalkVolume(PawnOwner.PhysicsVolume) != None && WalkVolume(PawnOwner.PhysicsVolume).bActive)
	{
		return false;
	}

	if (PawnOwner.WorldInfo.TimeSeconds < LastRunStopTime + RestTime)
	{
		return false;
	}

	return GearWeap_RetroLancer(PawnOwner.Weapon) != None;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local GearPC	PCToPlay;

	Super.SpecialMoveStarted(bForced, PrevMove);

	PawnOwner.BS_Play(BS_CustomRoadieRun, 1.0, 0.25f, 0.25f, true);
	RunTime = 0.0;
	bIsScreaming = false;

	PlayBladeSound();

	PCToPlay = GearPC(PawnOwner.Controller);
	if (PCToPlay != None && PawnOwner.IsLocallyControlled() && PCToPlay.PlayerCamera != None)
	{
		PCToPlay.MainPlayerInput.ForcePitchCentering(TRUE);
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	PawnOwner.BS_Stop(BS_CustomRoadieRun, 0.67f);
	LastRunStopTime = PawnOwner.WorldInfo.TimeSeconds;

	PawnOwner.MyGearWeapon.MIC_WeaponSkin.SetScalarParameterValue('RetroCharge', 0.0);

	Super.SpecialMoveEnded(PrevMove, NextMove);

	PawnOwner.StopMeleeAttack();
	PawnOwner.MyGearWeapon.EndOfMeleeAttack();

	if (NextMove == SM_None)
	{
		//Start panting at the end
		StartLoopingSounds();
		//Since we do not let the superclass stop the sounds at the end of the move, we must stop them ourselves
		PawnOwner.SetTimer( RestTime, FALSE, nameof(StopLoopingSounds), self);
	}

	if (ScreamSound != None)
	{
		ScreamSound.FadeOut(0.5f, 0);
	}

	PawnOwner.ClearTimer( nameof(PlayBladeSound), self);

	PawnOwner.LastRoadieRunTime = PawnOwner.WorldInfo.TimeSeconds;
	PawnOwner.LastMeleeAttackTime = PawnOwner.WorldInfo.TimeSeconds;
}

// play  blade sound - very short
function PlayBladeSound()
{
	PawnOwner.AttachComponent(BladeSound);
	BladeSound.Play();
	PawnOwner.ClearTimer( nameof(PlayBladeSound), self);
}

//The run has lasted long enough to initiate the scream
event StartScreaming()
{
	bIsScreaming = true;

	if (PawnOwner.bIsInCombat || (PawnOwner.WorldInfo.GRI != None && PawnOwner.WorldInfo.GRI.IsMultiplayerGame()))
	{
		ScreamSound = PawnOwner.SoundGroup.PlayEffortEx(PawnOwner, GearEffort_BayonetChargeStart, 0.0f);

		Super.StopLoopingSounds();
	}
}

//The run has lasted long enough that it is time to run out of gas
event StopScreaming()
{
	if (PawnOwner.Role == ROLE_Authority)
	{
		PawnOwner.ServerEndSpecialMove(SM_RoadieRunStab);
	}
}

simulated function PreProcessInput(GearPlayerInput Input)
{
	Super.PreProcessInput(Input);

	Input.aLookUp = 0;
}

defaultproperties
{
	bShouldAbortWeaponReload=TRUE
	bCheckForCancelAtStart=false
	bDisallowReverseTransitions=true

	MinSpeedPercent=0.9
	SteeringPct=0.25

	Begin Object Class=AudioComponent Name=BladeSound0
		SoundCue=SoundCue'Weapon_AssaultRifle.Pendulum.LancerPendulum_BayonetExtend_Cue'
	End Object
	BladeSound=BladeSound0

	bStopLoopingSoundsAtEndOfMove=false

	BS_CustomRoadieRun=(Stance=((Slot=BS_FullBody,AnimName="ADD_RL_RoadieRun_Fwd")))

	bShowHUDActions=TRUE
}
