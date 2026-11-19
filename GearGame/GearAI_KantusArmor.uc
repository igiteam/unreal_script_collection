/**
 * Armored Kantus AI
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearAI_KantusArmor extends GearAI_Kantus
	config(AI);

/** How much damage must be taken before we scream */
var config float ScreamOnDamageThreshold;

/** How long after the scream before the kantus can attack again */
var config float MinTimeBetweenScreamAndAttack;

/** When the last melee happened */
var transient float LastMeleeAttackTime;

/** How much time should there be before we can melee again */
var config float MinTimeBetweenMeleeAttacks;

/**
 * Force single burst firing and tell the alt pistol to fire
 *
 * @param InBurstsToFire - How many bursts to fire before stopping
 */
event StartFiring(optional int InBurstsToFire=-1)
{
	InBurstsToFire = GearWeapon(Pawn.Weapon).GetBurstFireCount();
	Super.StartFiring(InBurstsToFire);
}

/** Make sure the AI knows we're still firing if the second weapon is going */
function bool IsFiringWeapon()
{
	local GearPawn_LocustKantusArmorBase Kantus;

	Kantus = GearPawn_LocustKantusArmorBase(Pawn);

	return Super.IsFiringWeapon() || Kantus.AltWeapon.IsFiring() || Kantus.Weapon.IsTimerActive('FireAltWeapon');
}

/**
 * Start screaming if we're getting up from a stumble
 *
 * @param LastMove - the last special move executed
 */
function NotifyEndOfSpecialMove(GearPawn.ESpecialMove LastMove)
{
	Super.NotifyEndOfSpecialMove(LastMove);

	if (LastMove == SM_StumbleGetUp)
	{
		ReactionManager.NudgeChannel(Self, 'StumbleScream');
	}
}

/** Overloaded to not go to banzai mode */
function BanzaiAttack();

/**
 * Block the Kantus from attacking right after screaming
 *
 * @param Wpn - the weapon to fire
 *
 * @param FireModeNum - which fire mode we're trying to fire
 */
function bool CanFireWeapon(Weapon Wpn, byte FireModeNum)
{
	return (WorldInfo.TimeSeconds - GearPawn_LocustKantusBase(Pawn).LastSuccessfulKnockdownTime >= MinTimeBetweenScreamAndAttack && Super.CanFireWeapon(Wpn, FireModeNum));
}

/**
 * Do a roll attack instead of the standard melee
 * 
 * @param NewEnemy - the enemy to melee attack
 * 
 * @param InTarget - the target to melee towards
 */
function DoMeleeAttack(optional Pawn NewEnemy, optional Actor InTarget)
{	
	if (!GearPawn(Pawn).IsDoingASpecialMove() && (CachedAICommandList == None || CachedAICommandList.IsAllowedToFireWeapon()))
	{
		if (NewEnemy != None && NewEnemy != Enemy)
		{
			SetEnemy(NewEnemy);
		}

		// Make sure that we don't fire right away after doing the roll
		GearPawn_LocustKantusBase(Pawn).LastSuccessfulKnockdownTime = WorldInfo.TimeSeconds;

		LastMeleeAttackTime = WorldInfo.TimeSeconds;
		GearPawn(Pawn).ServerDoSpecialMove(GSM_KantusArmor_RollAttack);
	}
}

/**
 * Force melee attacks to wait a bit after doing the roll
 * 
 * @return TRUE if we can roll again now
 */
function bool CanEngageMelee()
{
	if (`TimeSince(LastMeleeAttackTime) < MinTimeBetweenMeleeAttacks)
	{
		return FALSE;
	}

	return Super.CanEngageMelee();
}

defaultproperties
{
	DefaultReactConditions.Remove(TriggerWeaponSwitch0)
	DefaultReactConditions.Remove(KantusTargetedReaction0)
	DefaultReactConditionClasses.Remove(class'AIReactCond_Stumble')
	DefaultReactConditions.Remove(ScreamThresh0)

	DefaultReactConditionClasses.Add(class'AIReactCond_KantusArmor_Stumble')

	Begin Object Class=AIReactCond_GenericPushCommand Name=StumbleGetUpScream0
		AutoSubscribeChannels(0)=StumbleScream
		MinTimeBetweenOutputsSeconds=-1
		CommandClass=class'AICmd_Kantus_FrustratedScream'
		bAlwaysNotify=TRUE
	End Object
	DefaultReactConditions.Add(StumbleGetUpScream0)

	CombatMood=AICM_Aggressive
}
