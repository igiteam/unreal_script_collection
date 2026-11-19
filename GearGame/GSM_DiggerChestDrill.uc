/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GSM_DiggerChestDrill extends GSM_BasePlaySingleAnim;

/** reference to the digger projectile (only valid on server) */
var GearProj_DiggerMissile Digger;

/** blood effect played on the victim */
var ParticleSystemComponent BurrowBlood;
/** different particle template if it's Lambent */
var ParticleSystem LambentBloodTemplate;
var ParticleSystem FormerBloodTemplate;

/** Chest drill vibration */
var ForceFeedbackWaveform ChestDrillFF;

function SpecialMoveStarted(bool bForced, ESpecialMove PrevMove)
{
	Super.SpecialMoveStarted(bForced, PrevMove);

	// score the death
	if (PawnOwner.Role == ROLE_Authority && Digger.InstigatorController != None)
	{
		if (!PawnOwner.bWasDBNO)
		{
			// translate the remaining health as damage done
			GearPRI(PawnOwner.PlayerReplicationInfo).ScoreHit(GearPRI(Digger.InstigatorController.PlayerReplicationInfo), PawnOwner.DefaultHealth, PawnOwner.Health, PawnOwner.Health, class'GDT_DiggerGrenade', Digger);
			// and insta kill
			GearPRI(Digger.InstigatorController.PlayerReplicationInfo).ScoreInstantKill(GearPRI(PawnOwner.PlayerReplicationInfo), class'GDT_DiggerGrenade', GDT_NORMAL);
		}
		else
		{
			// otherwise it's just an execution
			GearPRI(Digger.InstigatorController.PlayerReplicationInfo).ScoreExecution(GearPRI(PawnOwner.PlayerReplicationInfo), class'GDT_DiggerGrenade', GDT_NORMAL);
		}
	}
}

function bool CanOverrideSpecialMove(ESpecialMove InMove)
{
	return (InMove == SM_Kidnapper);
}

/** sound timers */
final function PlayBiteSound()
{
	PawnOwner.PlaySound(SoundCue'Weapon_Digger.Digger.Digger_BodyBite_Cue', true);
}
final function PlayRipSound()
{
	PawnOwner.PlaySound(SoundCue'Weapon_Digger.Digger.Digger_BodyRip_Cue', true);
}

function PlayAnimation()
{
	local float AnimLength;

	AnimLength = PawnOwner.BS_Play(BS_Animation, SpeedModifier, BlendInTime/SpeedModifier, BlendOutTime/SpeedModifier, FALSE);
	if (AnimLength > 1.25)
	{
		// the current anim is a little too long so set a timer to end it early
		PawnOwner.SetTimer(AnimLength - 1.25, false, nameof(EndThisSpecialMove), self);

		// play sound a bit before the explosion
		if (Digger != None)
		{
			Digger.SetTimer(AnimLength - 1.25 - Digger.GrenadeExplosionDelay, false, nameof(Digger.ArmGrenade));
		}
	}
	else
	{
		// Failed to play animation, fall back to just setting a timer to exit the special move.
		`warn("Failed to play animation on special move" @ Self @ "on Pawn" @ PawnOwner @ "defaulting to a timer to end special move");
		PawnOwner.SetTimer(0.25f, FALSE, nameof(Self.EndThisSpecialMove), Self);
	}

	if (PawnOwner.WorldInfo.GRI != None && PawnOwner.WorldInfo.GRI.ShouldShowGore())
	{
		if (GearPawnFX_Former(PawnOwner.GearPawnFX) != none)
		{
			BurrowBlood.SetTemplate(FormerBloodTemplate);
		}
		else if (PawnOwner.GetTeamNum() == TEAM_LAMBENT)
		{
			BurrowBlood.SetTemplate(LambentBloodTemplate);
		}
		else
		{
			BurrowBlood.SetTemplate(default.BurrowBlood.Template);
		}

		PawnOwner.AttachComponent(BurrowBlood);
		BurrowBlood.ActivateSystem();
	}

	PawnOwner.SetTimer(0.5, false, nameof(PlayBiteSound), self);
	PawnOwner.SetTimer(1.0, false, nameof(PlayRipSound), self);

	if (PCOwner.IsLocalPlayerController())
	{
		PCOwner.ClientPlayForceFeedbackWaveform(ChestDrillFF);
	}
}

function SpecialMoveEnded(ESpecialMove PrevMove, ESpecialMove NextMove)
{
	if (PawnOwner.Role == ROLE_Authority && !PawnOwner.InGodMode() && !PawnOwner.bUnlimitedHealth)
	{
		PawnOwner.TearOffMomentum = Normal(PawnOwner.Location - Digger.Location);
		PawnOwner.Died(Digger.InstigatorController, class'GDT_DiggerGrenade', PawnOwner.Location);
		Digger.DoExplosion();
	}

	if (PCOwner.IsLocalPlayerController())
	{
		PCOwner.ClientStopForceFeedbackWaveform(ChestDrillFF);
	}

	BurrowBlood.DeactivateSystem();

	PawnOwner.ClearTimer(nameof(PlayBiteSound), self);
	PawnOwner.ClearTimer(nameof(PlayRipSound), self);

	Super.SpecialMoveEnded(PrevMove, NextMove);
}

defaultproperties
{
	BS_Animation=(Stance=((Slot=BS_FullBody,AnimName="AR_Melee_Saw_Death")))
	BlendOutTime=0.0

	Begin Object Class=ParticleSystemComponent Name=BurrowFX
		Template=ParticleSystem'Effects_Gameplay.Blood.P_ChainSaw_Blood_01'
		bAutoActivate=false
		Translation=(X=50.0,Z=50.0)
	End Object
	BurrowBlood=BurrowFX
	LambentBloodTemplate=ParticleSystem'Effects_Gameplay.Blood_Lambent.P_ChainSaw_Blood_Lambent_01'
	FormerBloodTemplate=ParticleSystem'Effects_Gameplay.Blood_Lambent.P_ChainSaw_Blood_DarkDrones'
	bBreakFromCover=true
	bDisableTurnInPlace=true
	bShouldAbortWeaponReload=true
	bCanFireWeapon=false
	bDisableMovement=true
	bLockPawnRotation=true
	bDisableAI=true
	bDisableLook=true
	bCameraFocusOnPawn=true

	bDoMeshFloorConform=false
	bDoIKFloorConform=false
	bDoFootPlacement=false

	DefaultAICommand=class'AICmd_Base_PushedBySpecialMove'
	
	Begin Object Class=ForceFeedbackWaveform Name=ForceFeedbackWaveformChestDrill0
		Samples(0)=(LeftAmplitude=75,RightAmplitude=75,LeftFunction=WF_Noise,RightFunction=WF_Noise,Duration=5.0)
		bIsLooping=TRUE
	End Object
	ChestDrillFF=ForceFeedbackWaveformChestDrill0
}
