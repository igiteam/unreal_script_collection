/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 *
 */
class GearPawn_LocustBoomerBase extends GearPawn_LocustBase
	abstract
	config(Pawn);

/** This is needed to have the cooker correctly cook things that are currently DLO'd from config files **/
var class<Inventory> DefaultWeapon;

/** Weapon Firing animation */
var()	BodyStance	BS_WeaponFire;
/** Melee Attack animation */
var()	BodyStance	BS_MeleeAttack;


/** Boomer uses a single footstep sound for all matter types **/
var SoundCue FootStepSound;

/** How far away the foot steps can be felt **/
var config float DistanceToFeelFootSteps;

/** How much damage the boomer does when meleeing **/
var config float BoomerMeleeDamage;

/** lines to play right before an attack.  e.g. "Boom", "Crush", etc. */
var protected array<SoundCue>		BoomerAttackTelegraphDialogue;

/** lines to play before charging, e.g. "Boom", "Crush", etc. */
var protected const array<SoundCue>		BoomerChargeTelegraphDialogue;

/** To avoid super-repetitive telegraphs in siege. */
var() protected const float             BoomerTelegraphChance_Siege;
var() protected const float             BoomerChargeDialogueChance_Siege;

var protected const bool bChargeTelegraphInSiegeOnly;
var protected const bool bLaughInSiegeOnly;


/** lines to play for laughing/chuckling. */
var protected const array<SoundCue>		BoomerAttackChuckleDialogue;
var protected const float				BoomerAttackChuckleChance;

var array<name> HitReactionAnims;
var int LastHitReactionAnimIndex;
var float LastHitReactionAnimTime;

/** used to moderate calls to TelegraphAttack() when human controlled, since the player can spam the fire button */
var bool bDoPCTelegraphAttack;
var float LastPCTelegraphAttackTime;

var bool bPlayWeaponFireAnim;

/** The forcefeedback waveform to play with footsteps */
var ForceFeedbackWaveform FootstepShake;

/** @hack so we can stop anim tree camera anims if we gib */
var array<CameraAnim> CameraAnimsUsedByAnimTree;

/** Boomers can't be special melee attacked **/
simulated function bool CanBeSpecialMeleeAttacked( GearPawn Attacker )
{
	return FALSE;
}

/** "chaaarrrrrgeee" */
function TelegraphCharge()
{
	local int RandIdx;
	local bool bPlayingSiege;

	`SpeechLog(self@"telegraphing CHARGE"@BoomerChargeTelegraphDialogue.length);

	// speak telegraph line
	if (BoomerChargeTelegraphDialogue.length > 0)
	{
		bPlayingSiege = GearPC_Siege(Controller) != None;
		if ( (bPlayingSiege && FRand() < BoomerChargeDialogueChance_Siege ) ||
			 (!bPlayingSiege && !bChargeTelegraphInSiegeOnly) )
		{
			RandIdx = Rand(BoomerChargeTelegraphDialogue.length);

			// make addressee AI's target?
			SpeakLine(None, BoomerChargeTelegraphDialogue[RandIdx], "", 0.f, Speech_Immediate);
		}
	}
}

function TelegraphAttack()
{
	local int RandIdx;
	local bool bPlayingSiege;

	`SpeechLog(self@"telegraphing Attack"@BoomerAttackTelegraphDialogue.length);

	// speak telegraph line
	if (BoomerAttackTelegraphDialogue.length > 0)
	{
		bPlayingSiege = GearPC_Siege(Controller) != None;

		if ( !bPlayingSiege || FRand() < BoomerTelegraphChance_Siege )
		{
			RandIdx = Rand(BoomerAttackTelegraphDialogue.length);

			// make addressee AI's target?
			SpeakLine(None, BoomerAttackTelegraphDialogue[RandIdx], "", 0.f, Speech_Immediate);
		}

		if ( (BoomerAttackChuckleDialogue.length > 0) && (FRand() < BoomerAttackChuckleChance) )
		{
			SetTimer( RandRange(2.5f,3.5f), FALSE, nameof(PlayAttackChuckle) );
		}
	}

	super.TelegraphAttack();
}


simulated function PlayAttackChuckle()
{
	local int RandIdx;
	local bool bPlayingSiege;

	`SpeechLog(self@"doing ATTACK CHUCKLE"@BoomerAttackTelegraphDialogue.length);

	// speak line
	if ( (BoomerAttackChuckleDialogue.length > 0) && (Health > 0) )
	{
		bPlayingSiege = GearPC_Siege(Controller) != None;
		if (bPlayingSiege || !bLaughInSiegeOnly)
		{
			RandIdx = Rand(BoomerAttackChuckleDialogue.length);

			// make addressee AI's target?
			SpeakLine(None, BoomerAttackChuckleDialogue[RandIdx], "", 0.f, Speech_GUDS,,,,,, FALSE);
		}
	}
}

simulated event PlayFootStepSound( int FootDown )
{
	local PlayerController PC;

	// if we are dead then don't play footstep sounds
	if (!bPlayedDeath)
	{
		Super.PlayFootStepSound( FootDown );

		// play a rumble when boomer walks around
		foreach LocalPlayerControllers(class'PlayerController', PC)
		{
			if (PC.ViewTarget != None && VSize(PC.ViewTarget.Location - Location) < DistanceToFeelFootSteps)
			{
				PC.ClientPlayForceFeedbackWaveform(FootstepShake);
			}
		}

		PlaySound(FootStepSound, true, true, false, Location, true);
	}
}

/** @see Pawn::WeaponFired */
simulated function WeaponFired(Weapon InWeapon, bool bViaReplication, optional vector HitLocation)
{
	Super.WeaponFired(InWeapon, bViaReplication, HitLocation);

	if( bPlayWeaponFireAnim )
	{
		BS_Play(BS_WeaponFire, 1.f, 0.1f, 0.2f, FALSE, TRUE);
	}

	// players don't telegraph so just play the line at the same time as firing
	if (Role == ROLE_Authority && IsHumanControlled())
	{
		if (bDoPCTelegraphAttack && WorldInfo.TimeSeconds - LastPCTelegraphAttackTime > 3.0)
		{
			TelegraphAttack();
			LastPCTelegraphAttackTime = WorldInfo.TimeSeconds;
		}
		bDoPCTelegraphAttack = false;
	}
}

simulated function WeaponStoppedFiring(Weapon InWeapon, bool bViaReplication)
{
	Super.WeaponStoppedFiring(InWeapon, bViaReplication);

	bDoPCTelegraphAttack = true;
}


/**
 * Function allowing the Pawn to override a weapon melee attack with his own version.
 * @param	out_AnimTime	Play length of the animation played.
 * @return					TRUE to override, FALSE to let weapon play default animations.
 */
simulated function bool OverridePlayMeleeAttackAnim(out float Out_AnimTime)
{
	// Play melee attack animation
	Out_AnimTime = BS_Play(BS_MeleeAttack, 1.f, 0.1f, 0.2f, FALSE, TRUE);
	return TRUE;
}

simulated function bool GetMeleeDamageOverride( out float out_Damage )
{
	out_Damage = BoomerMeleeDamage;
	return TRUE;
}

/**
 * Boomer doesn't override boomshot animsets, this is only for Marcus.
 */
simulated function BuildScriptAnimSetList()
{
	Super(Pawn).BuildScriptAnimSetList();
}

/** Raam always modifies his damage **/
simulated function SetDontModifyDamage( bool NewValue );


/**
 * We override this so we can tell the boomshot that boomers are using to not use the melee timer.
 * Boomers use a big swipe attack that needs the MeleeImpact to occurr at the apex of the swipe
 **/
function AddDefaultInventory()
{
	local GearWeapon WW;

	Super.AddDefaultInventory();

	WW = GearWeapon(FindInventoryType(DefaultWeapon));

	if( WW != none )
	{
		WW.bUseMeleeHitTimer=FALSE;
	}
}

/** Override Infantry Pawn */
/** Sets the animsets for this mesh to be rotation only */
simulated function SetAnimRotationOnly();

simulated function bool PlayNearMissCringe()
{
	local BodyStance	BS_Cringe;

	return FALSE;

	if( !IsAliveAndWell() )
	{
		return FALSE;
	}

	// Do not overwrite currently playing animations on full body slot.
	// Have a delay between cringes.
	if( FullBodyNode != None && !FullBodyNode.bIsPlayingCustomAnim && !IsReloadingWeapon() )
	{
		BS_Cringe.Stance.Length = 1; // Array of struct needs to be pre-sized.
		BS_Cringe.Stance[0].Slot = BS_FullBody;
		BS_Cringe.Stance[0].AnimName = 'ADD_HW_Cringe_Light';
		BS_PlayByDuration(BS_Cringe, 1.f, 0.1f, 0.4f);
		return TRUE;
	}

	return FALSE;
}

/** Play Hit Reaction animation */
simulated function bool TryPlayHitReactionAnimation(ImpactInfo Impact)
{
`if(`notdefined(FINAL_RELEASE))
	// debugging headshots, don't move
	if (bWeaponDebug_HeadShotLocation)
	{
		return FALSE;
	}
`endif

	// Need a bone name to do something...
	if( Impact.HitInfo.BoneName == '' || `TimeSince(NextHitReactionAnimTime) < 0 )
	{
		return FALSE;
	}

	// Disable when doing special moves
	if( IsDoingASpecialMove() || bPlayedDeath )
	{
		return FALSE;
	}

	return PlayHitReactionAnimation(Impact);
}

/** Play Hit Reaction animation */
simulated function bool PlayHitReactionAnimation(ImpactInfo Impact)
{
	local BodyStance	BS_HitReaction;
	local INT			AnimIndex;
	local Name			AnimName;

	// Find an animation to play based on which bone was hit.
	if( MatchNameArray(Impact.HitInfo.BoneName, RightShoulderBones) )
	{
		AnimIndex = 0;
	}
	else if( MatchNameArray(Impact.HitInfo.BoneName, LeftShoulderBones) )
	{
		AnimIndex = 1;
	}
	else
	{
		AnimIndex = 2;
	}

	// Make sure we play two different animations in a row if hit less and a second ago.
	if( LastHitReactionAnimIndex == AnimIndex && `TimeSince(LastHitReactionAnimTime) < 1.f )
	{
		AnimIndex += FRand() < 0.5 ? +1 : -1;
		if( AnimIndex >= HitReactionAnims.Length )
		{
			AnimIndex = 0;
		}
		else if( AnimIndex < 0 )
		{
			AnimIndex = HitReactionAnims.Length - 1;
		}
	}

	// If we're playing an animation on those nodes, don't override it.
	if( BodyStanceNodes[BS_Std_Idle_Lower].bIsPlayingCustomAnim || BodyStanceNodes[BS_Std_Up].bIsPlayingCustomAnim )
	{
		return FALSE;
	}

	//`DLog("Picked Index:" @ AnimIndex @ HitReactionAnims[AnimIndex] @ "Last Index:" @ LastHitReactionAnimIndex @ "TimeSinceLast:" @ `TimeSince(LastHitReactionAnimTime));
	AnimName = HitReactionAnims[AnimIndex];
	LastHitReactionAnimIndex = AnimIndex;
	LastHitReactionAnimTime = WorldInfo.TimeSeconds;
	if( AnimName != '' )
	{
		BS_HitReaction.Stance.Length = 2; // Array of struct needs to be pre-sized.
		BS_HitReaction.Stance[0].Slot = BS_Std_Idle_Lower;
		BS_HitReaction.Stance[0].AnimName = AnimName;

		BS_HitReaction.Stance[1].Slot = BS_Std_Up;
		BS_HitReaction.Stance[1].AnimName = AnimName;

		NextHitReactionAnimTime = WorldInfo.TimeSeconds + RandRange(0.5f, 1.5f);

		return (BS_Play(BS_HitReaction, 0.67f, 0.2f, 0.33f) > 0.f);
	}

	return FALSE;
}

simulated function bool OverrideReloadAnimation(GearWeapon GearWeap, out BodyStance BS_Animation)
{
	// no reload animation
	return FALSE;
}

simulated function bool OverrideHolsterAnimation(GearWeapon WP)
{
	return TRUE;
}

simulated function bool OverrideEquipAnimation(GearWeapon WP, float BlendInTime)
{
	return TRUE;
}

/**
 * @hack to stop camera anims played by the anim tree if we gib
 *
 * @param Killer - the controller that killed us
 *
 * @param GearDamageType - which damage type killed us
 *
 * @param HitLocation - where the damage occurred
 *
 * @return TRUE if death allowed
 */
function bool Died(Controller Killer, class<DamageType> GearDamageType, vector HitLocation)
{
	StopAnimTreeCameraAnimations();

	return Super.Died( Killer, GearDamageType, HitLocation );
}

/** @hack stop camera anims played by the anim tree if we gib */
function StopAnimTreeCameraAnimations()
{
	local int i;
	local GearPC GPC;

	GPC = GearPC(Controller);

	if (GPC != None && GPC.PlayerCamera != None)
	{
		for (i = 0; i < CameraAnimsUsedByAnimTree.Length; i++)
		{
			GPC.PlayerCamera.StopAllCameraAnimsByType(CameraAnimsUsedByAnimTree[i], TRUE);
		}
	}
}

function bool ShouldOtherEvadeMeInsteadOfMeleeing(GearPawn Other)
{
	// don't melee boomers unless there's a reasonable chance of killing them with it
	return (Health > 1000);
}

defaultproperties
{
	BaseEyeHeight=85
	EyeHeight=85

	bCanPlayPhysicsHitReactions=FALSE // not looking too good, so disabled.
	RightShoulderBones=("b_MF_Clavicle_R","b_MF_Armor_Sho_R","b_MF_UpperArm_R","b_MF_Forearm_R","b_MF_Hand_R")
	LeftShoulderBones=("b_MF_Clavicle_L","b_MF_Armor_Sho_L","b_MF_UpperArm_L","b_MF_Forearm_L","b_MF_Hand_L")
	HitReactionAnims=("AR_HitReact_RtSho","AR_HitReact_LtSho","AR_Boomer_HitReact")

	bCanDoRun2Cover=FALSE
	bCanDBNO=false
	bPlayDeathAnimations=TRUE

	DeathAnimHighFwd=("Death_Reaching")
	DeathAnimHighBwd=("death_back")
	DeathAnimStdFwd=("Death_Reaching")
	DeathAnimStdBwd=("death_back")
	DeathAnimStdLt=("Death_Blown_Lt")
	DeathAnimStdRt=("Death_Blown_Rt")

	bRespondToExplosions=false
	bCanMeleeShields=true
	bCanUseCover=false

	PhysHRMotorStrength=(X=250,Y=0)

	// Don't shrink limits for boomer on death.
	RagdollLimitScaleTable.Empty()

	DrawScale=1.1f

	Begin Object Name=CollisionCylinder
		CollisionRadius=+0060.000000
		CollisionHeight=+0090.000000
	End Object

	CrouchHeight=+60.0
	CrouchRadius=+40.0

	BS_WeaponFire=(Stance=((Slot=BS_Std_Up,AnimName="AR_Fire"),(Slot=BS_Std_Idle_Lower,AnimName="AR_Fire")))
	BS_MeleeAttack=(Stance=((Slot=BS_Std_Up,AnimName="AR_Swipe"),(Slot=BS_Std_Idle_Lower,AnimName="AR_Swipe")))

	GUDLineRepeatMin=2.0f

	NoticedGUDSPriority=130
	NoticedGUDSEvent=GUDEvent_NoticedBoomer

	SpecialMoveClasses.Empty
	SpecialMoveClasses(SM_RoadieRun)=class'GSM_Boomer_Charge'
	SpecialMoveClasses(SM_PushCover)=class'GSM_Boomer_PushCover'
	SpecialMoveClasses(SM_MidLvlJumpOver)=class'GSM_Boomer_Mantle'
	SpecialMoveClasses(SM_DeathAnim)=class'GSM_DeathAnim'
	PawnToPawnInteractionList.Empty
	ActionSpecialMoves.Add(SM_MidLvlJumpOver)

	bTargetingNodeIsInIdleChannel=false
	bPlayWeaponFireAnim=true
	bDoPCTelegraphAttack=true
	bDoDeathUpKick=false

	bDebugSpeech=false

	ExtentPercentageForLedgeChecks=0.6f

	Begin Object Class=ForceFeedbackWaveform Name=FootstepShake0
		Samples(0)=(LeftAmplitude=35,RightAmplitude=15,LeftFunction=WF_Constant,RightFunction=WF_Constant,Duration=0.100)
	End Object
	FootstepShake=FootstepShake0

	BoomerTelegraphChance_Siege=0.5f
	BoomerChargeDialogueChance_Siege=0.5f
}
