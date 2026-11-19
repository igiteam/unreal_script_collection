
/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GSM_ChainSawHold extends GearSpecialMove;

/** Kick off sound */
var SoundCue SpecialMeleeAttackStopSound;

/** Saw Animations */
var GearPawn.BodyStance BS_SawIntro, BS_SawLoop;

var array<ESpecialMove> ChainsawInteractionMoves;

var ForceFeedbackWaveForm ChainsawHoldFF;

/** amount of time before we start checking for something to chainsaw */
var() config float ChainsawWarmupTime;
/** whether the special move can be interrupted by damage */
var bool bInterruptedByDamage;

struct ChainsawTarget
{
	var GearPawn InteractionPawn;
	var ESpecialMove InteractionSM;
	var float Value;
};

protected function bool InternalCanDoSpecialMove()
{
	local WalkVolume WV;

	if (PawnOwner.IsDoingASpecialMove() && !PawnOwner.IsDoingMove2IdleTransition())
	{
		return FALSE;
	}
	// no chainsaw hold during force walk
	WV = WalkVolume(PawnOwner.PhysicsVolume);
	if (WV != None && WV.bActive && WV.bReducesMovementSpeed)
	{
		return false;
	}
	// extra check to avoid potential weapon swap chainsaw exploits
	if (PawnOwner == None || GearWeap_AssaultRifle(PawnOwner.Weapon) == None || PawnOwner.bSwitchingWeapons)
	{
		return FALSE;
	}
	return Super.InternalCanDoSpecialMove();
}

function bool CanOverrideMoveWith(ESpecialMove NewMove)
{
	local ESpecialMove TestSM;

	// Allow transition to those moves.
	foreach ChainsawInteractionMoves(TestSM)
	{
		if( TestSM == NewMove )
		{
			return TRUE;
		}
	}

	return FALSE;
}

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	bInterruptedByDamage = true;

	Super.SpecialMoveStarted(bForced,PrevMove);

	// play rumble for local player
	if( PCOwner != None && PCOwner.IsLocalPlayerController() )
	{
		PCOwner.ClientPlayForceFeedbackWaveform(class'GearWaveForms'.default.ChainSawRev);
		PawnOwner.SetTimer(ChainsawWarmupTime, false, nameof(StartIdleFF),self);
	}

	// Make sure weapon effects/sounds are started as well.
	GearWeap_AssaultRifle(PawnOwner.MyGearWeapon).StartBlade();

	// SpecialMoveFlags of 1 means we're resuming holding, so we don't need to play the intro again.
	if( PawnOwner.SpecialMoveFlags == 1 )
	{
		PawnOwner.BS_Play(BS_SawLoop, 1.0, 0.f, 0.0, true);

		// rev animation is done, now disable interruption
		bInterruptedByDamage = false;
	}
	else
	{
		// start the intro pose
		PawnOwner.BS_PlayByDuration(BS_SawIntro, ChainsawWarmupTime, 0.3, -1.0);
		PawnOwner.BS_SetAnimEndNotify(BS_SawIntro, TRUE);
	}

	// Do that on servers only, so there's no confusion as to what the player is doing.
	if (PawnOwner.Role == ROLE_Authority)
	{
		// start checking for an interaction, initial delay to prevent spamming attacks
		PawnOwner.SetTimer(ChainsawWarmupTime, false, nameof(CheckForChainsawInteraction), self);
	}

	if (PawnOwner.Role == ROLE_Authority)
	{
		PawnOwner.MakeNoise(0.2);
		PawnOwner.SetTimer(0.5, true, nameof(ChainsawMakeNoiseLoop), self);
	}
}

/** When Pawn Rotation is locked, disable AimOffset */
event bool DisableAimOffset()
{
	return (Super.DisableAimOffset() || (PawnOwner.BS_IsPlaying(BS_SawIntro)));
}

/** called on a looping timer to notify AI about the noise caused by someone rampaging around with a rev'ed chainsaw */
final function ChainsawMakeNoiseLoop()
{
	PawnOwner.MakeNoise(0.125);
}

function StartIdleFF()
{
	if (PCOwner != None && PawnOwner != None && PawnOwner.SpecialMove == SM_ChainsawHold)
	{
		PCOwner.ClientPlayForceFeedbackWaveform(ChainsawHoldFF);
	}
}

function StopIdleFF()
{
	PawnOwner.ClearTimer(nameof(StartIdleFF),self);
	if (PCOwner != None)
	{
		PCOwner.ClientStopForceFeedbackWaveform(ChainsawHoldFF);
	}
}

function BS_AnimEndNotify(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	if (PawnOwner.BS_SeqNodeBelongsTo(SeqNode, BS_SawIntro))
	{
		PawnOwner.BS_SetAnimEndNotify(BS_SawIntro, false);
		PawnOwner.BS_Stop(BS_SawIntro, 0.3);
		PawnOwner.BS_Play(BS_SawLoop, 1.0, 0.3, 0.0, true);

		// rev animation is done, now disable interruption
		bInterruptedByDamage = false;
	}
}

final function CheckForChainsawInteraction()
{
	local GearPawn		FoundPawn, InteractionPawn;
	local ESpecialmove	TestSM, InteractionSM;
	local Trigger_ChainsawInteraction Trigger;
	local GearDestructibleObject GDO;
	local array<SequenceEvent> ActivatedEvts;
	local int i;
	local vector HitLocation, HitNormal;
	local array<ChainsawTarget> Targets;
	local ChainsawTarget NewTarget;
	local bool bInteractionObstructed, bMaybeBash;
	local Actor HitA;
	local GearGame Game;
	local bool bHitShield;
	local GearFortification BashTarget;
	local float DefaultMeleeDistance, MiniCorpserDistance, DistanceSquare;

	if( PawnOwner.WorldInfo.NetMode == NM_Client )
	{
		`warn(GetFuncName()@"called on a client");
		return;
	}

	// make sure the special move hasn't changed
	if (PawnOwner.SpecialMove != SM_ChainsawHold)
	{
		return;
	}

	// make sure the weapon hasn't changed, and is in the correct state
	if ( GearWeap_AssaultRifle(PawnOwner.Weapon) == None || PawnOwner.bSwitchingWeapons ||
		PawnOwner.Weapon.CurrentFireMode != class'GearWeapon'.const.MELEE_ATTACK_FIREMODE )
	{
		return;
	}

	// can't be interrupted once we enter the active phase
	bInterruptedByDamage = false;

	DefaultMeleeDistance = PawnOwner.GetMeleeAttackRange();
	MiniCorpserDistance = DefaultMeleeDistance * 1.25f; // 10% increase

	// Check for Nearby Pawns
	Game = GearGame(PawnOwner.WorldInfo.Game);
	foreach PawnOwner.WorldInfo.AllPawns(class'GearPawn', FoundPawn, PawnOwner.Location, MiniCorpserDistance)
	{
		// Make sure FoundPawn is in a state that can be interacted with
		// This is kept relatively simple, so the SpecialMove's CanInteractWith() function implements all the specifics
		if (FoundPawn == PawnOwner || !FoundPawn.IsGameplayRelevant() || GearGame(PawnOwner.WorldInfo.Game).IsRespawnInvincible(FoundPawn))
		{
			continue;
		}

		// Distance check
		DistanceSquare = VSizeSq(FoundPawn.Location - PawnOwner.Location);
		if( DistanceSquare > DefaultMeleeDistance*DefaultMeleeDistance && !FoundPawn.IsA('GearPawn_LocustCorpserLarvaUndergroundBase') )
		{
			continue;
		}

		// special case test for shields in the way, as VisibleCollidingActors() only checks world geometry
		// but shields are big enough that they should prevent chainsawing someone on the other side
		for (i = 0; i < Game.DeployedShields.Length; i++)
		{
			if (PawnOwner.TraceComponent(HitLocation, HitNormal, Game.DeployedShields[i].ShieldMeshComp, FoundPawn.Location, PawnOwner.Location))
			{
				bHitShield = true;
				break;
			}
		}

		if (!bHitShield)
		{
			// If there's a pawn on the opposing team that we're facing and can't be special melee'd, try bashing
			if (!FoundPawn.CanBeSpecialMeleeAttacked(PawnOwner) && !PawnOwner.WorldInfo.GRI.OnSameTeam(FoundPawn, PawnOwner) && vector(PawnOwner.Rotation) dot Normal(FoundPawn.Location - PawnOwner.Location) >= 0)
			{
				bMaybeBash = true;
			}
			else
			{
				// test each move to see if valid, first come first serve for priority
				foreach ChainsawInteractionMoves(TestSM)
				{
					// See if we can perform an interaction with this Pawn
					if( PawnOwner.CanDoSpecialMovePawnInteraction(TestSM, FoundPawn) )
					{
						bInteractionObstructed = FALSE;
						// verify no intervening geometry
						//@note - delayed until we have a successful interaction since this will be the most expensive portion
						foreach PawnOwner.TraceActors(class'Actor',HitA,HitLocation,HitNormal,FoundPawn.Location,PawnOwner.Location,vect(32,32,32))
						{
							if (HitA == FoundPawn || (FoundPawn.IsAHostage() && HitA == FoundPawn.InteractionPawn))
							{
								// hit our target, don't check any further
								break;
							}
							if (HitA != FoundPawn && PawnOwner.IsBlockedBy(HitA))
							{
								//`log(self@GetFuncName()@"interaction obstructed to"@`showvar(FoundPawn)@"due to"@`showvar(HitA));
								bInteractionObstructed = TRUE;
								break;
							}
						}

						// Chainsaw the hostage if we're coming from the front
						// The hostage may not be in the consider list due to the radius check so force it in
						//`log(NoZDot(vector(FoundPawn.Rotation), vector(PawnOwner.Rotation)));
						if ( FoundPawn.IsAKidnapper() && FoundPawn.InteractionPawn.CanBeSpecialMeleeAttacked(PawnOwner) &&
							NoZDot(vector(FoundPawn.Rotation), vector(PawnOwner.Rotation)) < 0.5 )
						{
							FoundPawn = FoundPawn.InteractionPawn;
						}

						if (!bInteractionObstructed)
						{
							// Found an interaction!
							NewTarget.InteractionPawn = FoundPawn;
							NewTarget.InteractionSM = TestSM;
							Targets.AddItem(NewTarget);
						}
						// always break on the first success or first fail
						// - if we succeeded that means we can duel this target, so don't check the attack
						// - if we failed that means we wouldn't be able to attack either
						break;
					}
				}
			}
		}
	}
	// if only one target available then just pick that one
	if (Targets.Length == 1)
	{
		InteractionPawn = Targets[0].InteractionPawn;
		InteractionSM = Targets[0].InteractionSM;
	}
	else
	{
		// otherwise do a simple rating for each target so we can pick the best option
		for (i = 0; i < Targets.Length; i++)
		{
			// avoid DBNO players
			if (Targets[i].InteractionPawn.IsDBNO())
			{
				Targets[i].Value += 0.5f;
			}
			else
			{
				Targets[i].Value += 1.f;
			}
			// and avoid duels
			if (Targets[i].InteractionSM == SM_ChainsawAttack)
			{
				Targets[i].Value += 0.5f;
			}
			// check to see if this is the new best target
			if (NewTarget.Value < Targets[i].Value)
			{
				NewTarget = Targets[i];
			}
		}
		InteractionPawn = NewTarget.InteractionPawn;
		InteractionSM = NewTarget.InteractionSM;
	}
	// if we found somebody to play with
	if (InteractionPawn != None)
	{
		if( InteractionSM == SM_ChainsawAttack )
		{
			PawnOwner.ServerDoSpecialMove(SM_ChainsawAttack, TRUE, InteractionPawn, class'GSM_ChainsawAttack'.static.PackChainsawAttackFlags(FALSE,,PawnOwner, InteractionPawn));
		}
		else
		{
			// then start the interaction sm (which will trigger the sm on the interaction pawn eventually)
			PawnOwner.DoPawnToPawnInteraction(InteractionSM, InteractionPawn);
		}
	}
	else if (bMaybeBash)
	{
		// force the client to restart the firing process, which will get it bashing instead
		PawnOwner.MyGearWeapon.ClientForceEndFire(PawnOwner.MyGearWeapon.CurrentFireMode);
		PawnOwner.ClientStartMeleeAttack();
	}
	else
	{
		// check for objects to saw into
		foreach PawnOwner.TouchingActors(class'Trigger_ChainsawInteraction',Trigger)
		{
			if (Trigger.TriggerEventClass(class'SeqEvt_ChainsawInteraction',PawnOwner,0,TRUE,ActivatedEvts) || Trigger.bNoKismet)
			{
				if (Trigger.CurrentActivator != None && Trigger.CurrentActivator != PawnOwner && !Trigger.bActivatedByMelee)
				{
					continue;
				}
				// check to see if we should use the no-camera version
				if (SeqEvt_ChainsawInteraction(ActivatedEvts[0]) != None && SeqEvt_ChainsawInteraction(ActivatedEvts[0]).bDisableCamera)
				{
					PawnOwner.ServerDoSpecialMove(SM_ChainsawAttack_Object_NoCamera, TRUE, None, class'GSM_ChainsawAttack'.static.PackChainsawAttackFlags(FALSE));
				}
				else
				{
					// otherwise use the default
					PawnOwner.ServerDoSpecialMove(SM_ChainsawAttack_Object, TRUE, None, class'GSM_ChainsawAttack'.static.PackChainsawAttackFlags(FALSE));
				}
				// don't bother looking for more since the SM just changed
				return;
			}
		}
		foreach PawnOwner.VisibleCollidingActors(class'GearDestructibleObject', GDO, 96.f)
		{
			if(GDO.CanBeSpecialMeleeAttacked(PawnOwner))
			{
				PawnOwner.TargetedGDO = GDO;
				PawnOwner.ServerDoSpecialMove(SM_ChainsawAttack_Object, TRUE, None, class'GSM_ChainsawAttack'.static.PackChainsawAttackFlags(FALSE));
				return;
			}
		}
		foreach PawnOwner.VisibleCollidingActors(class'GearFortification', BashTarget, PawnOwner.MyGearWeapon.MeleeAttackRange)
		{
			if (!PawnOwner.WorldInfo.GRI.OnSameTeam(PawnOwner, BashTarget))
			{
				// force the client to restart the firing process, which will get it bashing instead
				PawnOwner.MyGearWeapon.ClientForceEndFire(PawnOwner.MyGearWeapon.CurrentFireMode);
				PawnOwner.ClientStartMeleeAttack();
				return;
			}
		}
		// otherwise check again next tick
		PawnOwner.SetTimer( 0.1f,FALSE,nameof(self.CheckForChainsawInteraction), self );
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	if (NextMove != SM_ChainsawDuel_Leader && NextMove != SM_ChainsawAttack && NextMove != SM_ChainsawAttack_Object && NextMove != SM_ChainsawAttack_Object_NoCamera && NextMove != SM_ChainsawDuel_Follower)
	{
		PawnOwner.PlaySound(SpecialMeleeAttackStopSound,TRUE,TRUE);
		// for whatever reason we aborted the hold, so make sure the weapon is sync'd
		PawnOwner.StopMeleeAttack(TRUE);
	}
	StopIdleFF();
	PawnOwner.ClearTimer('CheckForChainsawInteraction', Self);
	PawnOwner.BS_SetAnimEndNotify(BS_SawIntro, FALSE);
	PawnOwner.BS_Stop(BS_SawIntro, 0.2f);
	PawnOwner.BS_Stop(BS_SawLoop, 0.2f);

	if (PawnOwner.Role == ROLE_Authority)
	{
		PawnOwner.ClearTimer(nameof(ChainsawMakeNoiseLoop), self);
	}

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

simulated function PreProcessInput(GearPlayerInput Input)
{
	// strafe becomes turning
	Input.aTurn = Input.aStrafe;
	Input.aStrafe = 0.0;
}

defaultproperties
{
	BS_SawIntro=(Stance=((Slot=BS_Std_Up,AnimName="AR_Melee_Saw_Rev")))
	BS_SawLoop=(Stance=((Slot=BS_Std_Up,AnimName="ADD_AR_Melee_Saw_Idle")))

	SpecialMeleeAttackStopSound=SoundCue'Weapon_AssaultRifle.Melee.ChainsawStop01Cue'

	ChainsawInteractionMoves=(SM_ChainsawDuel_Leader,SM_ChainsawAttack)

	bCanFireWeapon=FALSE
	bShouldAbortWeaponReload=TRUE
	bNoStoppingPower=false

	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformChainsawHold1
		Samples(0)=(LeftAmplitude=35,RightAmplitude=35,LeftFunction=WF_Noise,RightFunction=WF_Noise,Duration=5.0)
		bIsLooping=TRUE
	End Object
	ChainsawHoldFF=ForceFeedbackWaveformChainsawHold1

	bShowHUDActions=TRUE
}
