
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_Tempest_BeamInAir extends GearSpecialMove;

/** specialmove flags **/
/** 0 - default case where normal target is given and you do beam attack @ the target **/
/** 1 - play animation continuous state from previous, but trigger to play animation **/
/** 2 - sweep case where you do beam attack @ the area **/

/** Target to shoot the beam at */
var Actor BeamTarget;

/** Attack animations **/
var transient BodyStance BS_AttackStart, BS_AttackLoop, BS_AttackEnd;
var BodyStance BS_AttackGroundStart, BS_AttackGroundLoop, BS_AttackGroundEnd;
var BodyStance BS_AttackHoverStart, BS_AttackHoverLoop, BS_AttackHoverEnd;
var BodyStance BS_AttackBalconyStart, BS_AttackBalconyLoop, BS_AttackBalconyEnd;

/** Trace if it's ready to fire. Once the start fire animation is done, it's ready **/
var transient bool bReadyToFire;
var transient bool bFireWhenReady;
var transient float FireBeamTime;
var transient bool bAttackAnimationStarted;

/** Set up animations to play depending on specialmoveFlags **/
function SetupAnimation()
{
	local GearPawn_LocustTempestBase Tempest;
	
	Tempest = GearPawn_LocustTempestBase(PawnOwner);

	// if specialmove flags is 1, use ground attack
	if ( Tempest.bLanded )
	{
		if ( Tempest.bBalconyMode )
		{
			BS_AttackStart = BS_AttackBalconyStart;
			BS_AttackLoop = BS_AttackBalconyLoop;
			BS_AttackEnd = BS_AttackBalconyEnd;
		}
		else
		{
			BS_AttackStart = BS_AttackGroundStart;
			BS_AttackLoop = BS_AttackGroundLoop;
			BS_AttackEnd = BS_AttackGroundEnd;
		}
	}
	else
	{
		// if not hover attack
		BS_AttackStart = BS_AttackHoverStart;
		BS_AttackLoop = BS_AttackHoverLoop;
		BS_AttackEnd = BS_AttackHoverEnd;
	}
}

/** Start beam attack animation **/
function StartBeamAttackAnimation()
{
	if ( bAttackAnimationStarted == FALSE )
	{
		// set up animation to see which one to use
		SetupAnimation();

		// play the attack start animation
		PawnOwner.BS_Play(BS_AttackStart, 1.f, 0.2f, 0.2f);
		PawnOwner.BS_SetAnimEndNotify(BS_AttackStart, TRUE);

		bAttackAnimationStarted = TRUE;
	}
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	// disallow combat transition that turns fire on/off
	PawnOwner.MyGearAI.bAllowCombatTransitions = false;

	// this is triggered from Kismet, and will rotate to target first
	// and when it's ready, it will fire
	// clear all variables and ready to rotate
	// this is waiting for beamtarget to be set
	bReadyToFire = FALSE;
	bFireWhenReady = FALSE;
	FireBeamTime = 0.f;
	bAttackAnimationStarted = FALSE;

	Super.SpecialMoveStarted(bForced,PrevMove);
}

/**
 * Notification called when body stance animation finished playing.
 * @param	SeqNode		- Node that finished playing. You can get to the SkeletalMeshComponent by looking at SeqNode->SkelComponent
 * @param	PlayedTime	- Time played on this animation. (play rate independant).
 * @param	ExcessTime	- how much time overlapped beyond end of animation. (play rate independant).
 */
function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	if (PawnOwner.BS_SeqNodeBelongsTo(SeqNode, BS_AttackStart))
	{
		PawnOwner.BS_Stop(BS_AttackStart, 0.2f);
		PawnOwner.BS_Play(BS_AttackLoop, 1.f, 0.25f, 0.25f, TRUE);
		TriggerBeamAttack();
	}
}

/** Trigger Beam Attack if it has been requested **/
simulated function TriggerBeamAttack()
{
	// you can do this in client, but it won't make any difference
	if (PawnOwner.Role == ROLE_Authority)
	{
		if (bReadyToFire == FALSE)
		{
			bReadyToFire = TRUE;
			if (bFireWhenReady)
			{
				SetBeamTime(FireBeamTime);
			}
		}
	}
}
/** Set timer for when we want to finish this move */
simulated function SetBeamTime(float BeamTime)
{
	local GearAI_LocustTempest TempestAI;

	// Set the timer for when we should stop the special move
	if (BeamTime > 0 &&
		PawnOwner.Role == ROLE_Authority)
	{
		// if not ready to fire, save info and trigger when it's ready
		if (bReadyToFire == FALSE)
		{
			bFireWhenReady = TRUE;
			FireBeamTime = BeamTime;
			// we need to rotate to target first before playing anything
			if (BeamTarget!=none)
			{
				// set desired rotation
				PawnOwner.SetDesiredRotation(rotator(BeamTarget.Location-PawnOwner.Location), TRUE, TRUE);
			}
			// do not go ahead and start fire, we need to wait until rotation is done and start animation is played
			return;
		}

		// clear variable 
		bFireWhenReady = FALSE;
		FireBeamTime = 0.f;

		TempestAI = GearAI_LocustTempest(PawnOwner.Controller);
		if (TempestAI != None)
		{
			PawnOwner.SetTimer(BeamTime, false, nameof(StopSpecialMove), self);
			TempestAI.FireTarget = BeamTarget;
			TempestAI.BeamAttackTarget = BeamTarget;
			//`log("Tempest Start Firing");
			TempestAI.StartFiring();
		}
	}
}

/** Tells the special move to stop */
function StopSpecialMove()
{
	PawnOwner.EndSpecialMove();
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	local GearAI_LocustTempest TempestAI;
	local GearPawn_LocustTempestBase Tempest;

	// now play end animation
	// play the attack start animation
	PawnOwner.BS_Stop(BS_AttackLoop, 0.2f);
	PawnOwner.BS_Play(BS_AttackEnd, 1.f, 0.2f, 0.2f);
	// I think I need to stop this

	if (PawnOwner.Role == ROLE_Authority)
	{
		TempestAI = GearAI_LocustTempest(PawnOwner.Controller);
		if (TempestAI != None)
		{
			//`log("Tempest Stop Firing");
			TempestAI.StopFiring();
			// clear them up, so that it can reselect target
			TempestAI.FireTarget = none;
			TempestAI.BeamAttackTarget = none;
			GearPawn_LocustTempestBase(PawnOwner).bSweepAttack = FALSE;
		}

		Tempest = GearPawn_LocustTempestBase(PawnOwner);
		Tempest.TriggerEventClass(class'SeqEvt_TempestAnimFinished', Tempest, 4);
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);

	// disallow combat transition that turns fire on/off
	PawnOwner.MyGearAI.bAllowCombatTransitions = true;
}

/** Notification forwarded by GearAnimNotify_SpecialMove */
function AnimNotify(AnimNodeSequence SeqNode, GearAnimNotify_SpecialMove NotifyObject)
{
	if ( NotifyObject.Info == 'StartBeamAttack' )
	{
		TriggerBeamAttack();
	}

	Super.AnimNotify(SeqNode, NotifyObject);
}

/** Script Tick function. */
function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	if (PawnOwner.Role == ROLE_Authority)
	{
		// if not sweep attack 
		if ( PawnOwner.SpecialMoveFlags == 0)
		{
			// pawn shouldn't stuck here if beamtarget died, so let it out if not found
			if (BeamTarget == none)
			{
				StopSpecialMove();
			}

			// once reached and if the animation hasn't started yet, start
			if ( BeamTarget!=none && PawnOwner.ReachedDesiredRotation() )
			{
				// if you trigger same SM, it will not retrigger SM, but only update flag
				// for replication, if you update flag, it will replicate to client
				PawnOwner.DoSpecialMove(SM_Tempest_BeamInAir, TRUE, , 1);
			}
		}
		else if ( PawnOwner.SpecialMoveFlags == 2)
		{
			// once reached and if the animation hasn't started yet, start
			if ( PawnOwner.ReachedDesiredRotation() )
			{
				// if you trigger same SM, it will not retrigger SM, but only update flag
				// for replication, if you update flag, it will replicate to client
				PawnOwner.DoSpecialMove(SM_Tempest_BeamInAir, TRUE, , 1);
			}
		}
	}

	// Flag has been updated and animation hasn't started yet
	if ( PawnOwner.SpecialMoveFlags == 1 && bAttackAnimationStarted == FALSE )
	{
		/// start beam attack 
		StartBeamAttackAnimation();
	}
}

defaultproperties
{
	BS_AttackHoverStart=(Stance=((Slot=BS_FullBody,AnimName="Attack_Hover_Start")))
	BS_AttackHoverLoop=(Stance=((Slot=BS_FullBody,AnimName="Attack_Hover_Loop")))
	BS_AttackHoverEnd=(Stance=((Slot=BS_FullBody,AnimName="Attack_Hover_End")))

	BS_AttackGroundStart=(Stance=((Slot=BS_FullBody,AnimName="Attack_Ground_Start")))
	BS_AttackGroundLoop=(Stance=((Slot=BS_FullBody,AnimName="Attack_Ground_Loop")))
	BS_AttackGroundEnd=(Stance=((Slot=BS_FullBody,AnimName="Attack_Ground_End")))

	BS_AttackBalconyStart=(Stance=((Slot=BS_FullBody,AnimName="Attack_Balcony_Start")))
	BS_AttackBalconyLoop=(Stance=((Slot=BS_FullBody,AnimName="Attack_Balcony_Loop")))
	BS_AttackBalconyEnd=(Stance=((Slot=BS_FullBody,AnimName="Attack_Balcony_End")))

	bLockPawnRotation = FALSE;
}