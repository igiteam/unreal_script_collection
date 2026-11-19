
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Berserker_Smash extends GearSpecialMove
	DependsOn(AnimSequence)
	native(SpecialMoves);

// C++ functions
cpptext
{
	virtual void TickSpecialMove(FLOAT DeltaTime);
}

var()	GearPawn.BodyStance	BS_Animation;

/** Old location of hands for traces during melee attack */
var()	Vector RHand_OldLocation, LHand_OldLocation;
/** Damage of attack is active */
var()	bool	bDamageActive;

var(Debug) bool bDebugLines;


/** Get Animation Play Rate */
simulated function float GetAnimPlayRate()
{
	local GearPawn_LocustBerserkerBase	Berserker;
	local GearPawn_LocustBerserkerLambentBase LambentBerserker;
	local float Modifier;

	Modifier = SpeedModifier;
	Berserker = GearPawn_LocustBerserkerBase(PawnOwner);

	// When heated up, animations play faster
	if( Berserker != None && Berserker.bVulnerableToDamage )
	{
		Modifier = Berserker.HeatedUpSpeedScale * SpeedModifier;
		LambentBerserker = GearPawn_LocustBerserkerLambentBase(Berserker);
		if (LambentBerserker != None && LambentBerserker.CurrentPhase < LambentBerserker.PhaseInfo.length)
		{
			Modifier *= LambentBerserker.PhaseInfo[LambentBerserker.CurrentPhase].AnimSpeed;
		}
	}

	return Modifier;
}


function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	local float AnimRate;
	local GearPawn_LocustBerserkerBase Berserker;

	Berserker = GearPawn_LocustBerserkerBase(PawnOwner);

	Super.SpecialMoveStarted(bForced,PrevMove);

	AnimRate = GetAnimPlayRate();

	// Play body stance animation.
	PawnOwner.BS_Play(BS_Animation, AnimRate, 0.3f/AnimRate, 0.3f/AnimRate, FALSE, TRUE);

	// Enable end of animation notification. This is going to call SpecialMoveEnded()
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, TRUE);

	// Have animation forward root motion.
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Translate, RBA_Translate, RBA_Translate);

	// Turn on Root motion on mesh. Use RMM_Accel, to drive full movement.
	PawnOwner.Mesh.RootMotionMode = RMM_Accel;
	
	// Warn nearby enemy AI of the attack
	Berserker.WarnAttackIncoming(Berserker.Location + Vector(Berserker.Rotation) * 200.f);
}


function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	Super.SpecialMoveEnded(PrevMove, NextMove);

	// Turn off Root motion on animation node
	PawnOwner.BS_SetRootBoneAxisOptions(BS_Animation, RBA_Discard, RBA_Discard, RBA_Discard);

	// Disable end of animation notification.
	PawnOwner.BS_SetAnimEndNotify(BS_Animation, FALSE);

	// Stop animation if it didn't already
	PawnOwner.BS_Stop(BS_Animation, 0.3f);

	// Restore default root motion mode
	PawnOwner.Mesh.RootMotionMode = PawnOwner.Mesh.default.RootMotionMode;

	RHand_OldLocation = vect(0,0,0);
	LHand_OldLocation = vect(0,0,0);
}

event MeleeDamageTo( Actor Other, Vector HitLocation )
{
	local GearPawn_LocustBerserkerBase BerserkerPawn;

	BerserkerPawn = GearPawn_LocustBerserkerBase(PawnOwner);
	if (BerserkerPawn != None)
	{
		BerserkerPawn.NotifyBerserkerSmashCollision(Other, HitLocation);
	}
}

defaultproperties
{
	bLockPawnRotation=TRUE
	bDisableAI=TRUE
	bDamageActive=TRUE
	bRestoreMovementAfterMove=FALSE

	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="Swinging_Attack")))
	//bDebugLines=TRUE
}
