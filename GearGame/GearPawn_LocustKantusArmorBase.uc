/**
 * Armored Kantus base class
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearPawn_LocustKantusArmorBase extends GearPawn_LocustKantusBase
	abstract
	config(Pawn);

/** The material that should be used when spawning bullet effects while blocking */
var PhysicalMaterial BlockedShotPhysMat;

/** Sound to play after blocking a ton of damage */
var SoundCue BlockedShotLaugh;

/** How much damage to block before playing the laugh */
var config float BlockedShotLaughThreshold;

/** How often to laugh */
var config float LaughFrequency;

/** The last time we caused laughed */
var transient float LastLaughTime;

/** How much should damage be reduced by */
var config float BlockedShotDamageReductionFactor;

/** The accumulator for blocked shot damage */
var float BlockedShotDamageAmount;

/** How much damage the scream should cause  */
var config Vector2D ScreamDamageRange;

/** The Armored Kantus dual wields */
var GearWeapon AltWeapon;

/** Control client side fire effects on the alternate weapon */
var repnotify Vector    AltFlashLocation;

/** Control client side fire effects on the alternate weapon */
var repnotify byte      AltFlashCount;

/** Control client side fire effects on the alternate weapon */
var repnotify byte      AltFiringMode;

/** The last time one of the pistols was fired */
var float LastFireTime;

/** The delay between primary and alternate weapon fires */
var config float DualPistolFireDelay;

/** Mouth Glow Effects */
var ParticleSystem MouthGlowPS;
var LensFlare MouthGlowLF;
var LensFlareComponent MouthGlowFlareComp;
var ParticleSystemComponent MouthGlowPSC;

replication
{
	if (bNetDirty)
		AltFlashLocation, AltFlashCount, AltFiringMode;
}

simulated event Destroyed()
{
	Super.Destroyed();

	// Clean up dynamic component references.
	if( MouthGlowFlareComp != None )
	{
		MouthGlowFlareComp = None;
	}

	if( MouthGlowPSC != None )
	{
		MouthGlowPSC = None;
	}
}

/** Clients should spawn their own second pistol */
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Role != ROLE_Authority)
	{
		AltWeapon = GearWeapon(RemoteClientGetInventoryByClass(DefaultInventory[1]));
		if (AltWeapon != None)
		{
			AttachWeaponToHand(AltWeapon);
		}
	}
}

/**
 * A client is taking over this Kantus, nuke the slave weapon
 *
 * It would be cleaner to never spawn it, but we don't know who owned the pawn in PostBeginPlay()
 */
simulated function ClientRestart()
{
	if (Role == ROLE_AutonomousProxy)
	{
		if (AltWeapon.bSlaveWeapon)
		{
			AltWeapon.Destroy();
			AltWeapon = GearWeapon(InvManager.FindInventoryType(DefaultInventory[1], TRUE));
			if (AltWeapon != None)
			{
				AttachWeaponToHand(AltWeapon);
			}
		}
	}

	Super.ClientRestart();
}

/** Always scream even if we aren't going to knock anything down */
function bool CanDoKnockdown()
{
	if( `TimeSince(LastSuccessfulKnockdownTime) < MinTimeBetweenKnockDownScreams )
	{
		return false;
	}
	else
	{
		Super.CanDoKnockdown();

		return true;
	}
}

/**
 * Control client side fire effects on the alternate weapon
 *
 * @param VarName - the variable being replicated
 */
simulated event ReplicatedEvent( name VarName )
{
	Super.ReplicatedEvent( VarName );

	if( VarName == 'AltFlashCount' )	// FlashCount and FlashLocation are changed when a weapon is fired.
	{
		FlashCountUpdated(AltWeapon, AltFlashCount, TRUE);
	}
	else if( VarName == 'AltFlashLocation' ) // FlashCount and FlashLocation are changed when a weapon is fired.
	{
		FlashLocationUpdated(AltWeapon, AltFlashLocation, TRUE);
	}
	else if( VarName == 'AltFiringMode' )
	{
		FiringModeUpdated(AltWeapon, AltFiringMode, TRUE);
	}
}


/**
 * Handle AltWeapon's pending fire
 *
 * @param InFiringMode - the firing mode to check
 */
simulated function bool IsWeaponPendingFire(Byte InFiringMode)
{
	if( InFiringMode == class'GearWeapon'.const.ALTFIRE_FIREMODE )
	{
		return (InvManager != None && InvManager.IsPendingFire(AltWeapon, 0));
	}

	return (InvManager != None && InvManager.IsPendingFire(Weapon, InFiringMode));
}

/**
 * Handle AltWeapon's pending fire
 *
 * @param InWeapon - the weapon to examine
 */
simulated function byte GetWeaponFiringMode(Weapon InWeapon)
{
	if( InWeapon == AltWeapon )
	{
		return AltFiringMode;
	}
	return Super.GetWeaponFiringMode(InWeapon);
}

/**
 * Handle setting AltWeapon's firing mode
 *
 * @param InWeapon - the weapon to change the firing mode on
 *
 * @param InFiringMode - the firing mode to set
 */
simulated function SetFiringMode(Weapon InWeapon, byte InFiringMode)
{
	local byte RealFiringMode;

	if( InWeapon == AltWeapon )
	{
		RealFiringMode = FiringMode;
		FiringMode = AltFiringMode;
		Super.SetFiringMode(InWeapon, InFiringMode);
		AltFiringMode = FiringMode;
		FiringMode = RealFiringMode;
	}
	else
	{
		Super.SetFiringMode(InWeapon, InFiringMode);
	}
}

/**
 * Handle AltWeapon's FlashCount
 *
 * @param InWeapon - the weapon fired
 *
 * @param InFiringMode - the firing mode of the weapon
 */
simulated function IncrementFlashCount(Weapon InWeapon, byte InFiringMode)
{
	local byte RealFlashCount;

	if( InWeapon == AltWeapon )
	{
		RealFlashCount = FlashCount;
		FlashCount = AltFlashCount;
		Super.IncrementFlashCount(InWeapon, InFiringMode);
		AltFlashCount = FlashCount;
		FlashCount = RealFlashCount;
	}
	else
	{
		Super.IncrementFlashCount(InWeapon, InFiringMode);
	}
}

/**
 * Handle AltWeapon's FlashCount
 *
 * @param InWeapon - the weapon connected to the FlashCount
 */
simulated function ClearFlashCount(Weapon InWeapon)
{
	local byte RealFlashCount;

	if( InWeapon == AltWeapon )
	{
		RealFlashCount = FlashCount;
		FlashCount = AltFlashCount;
		Super.ClearFlashCount(InWeapon);
		AltFlashCount = FlashCount;
		FlashCount = RealFlashCount;
	}
	else
	{
		Super.ClearFlashCount(InWeapon);
	}
}

/**
 * Handle AltWeapon's FlashLocation
 *
 * @param InWeapon - the weapon fired
 *
 * @param InFiringMode - the firing mode of the weapon
 *
 * @param NewLoc - the new FlashLocation
 */
simulated function SetFlashLocation(Weapon InWeapon, byte InFiringMode, vector NewLoc)
{
	local vector RealFlashLocation;

	if( InWeapon == AltWeapon )
	{
		RealFlashLocation = FlashLocation;
		FlashLocation = AltFlashLocation;
		Super.SetFlashLocation(InWeapon, InFiringMode, NewLoc);
		AltFlashLocation = FlashLocation;
		FlashLocation = RealFlashLocation;
	}
	else
	{
		Super.SetFlashLocation(InWeapon, InFiringMode, NewLoc);
	}
}

/**
 * Handle AltWeapon's FlashLocation
 *
 * @param InWeapon - the weapon to clear the flash location of
 */
function ClearFlashLocation(Weapon InWeapon)
{
	local vector RealFlashLocation;

	if( InWeapon == AltWeapon )
	{
		RealFlashLocation = FlashLocation;
		FlashLocation = AltFlashLocation;
		Super.ClearFlashLocation(InWeapon);
		AltFlashLocation = FlashLocation;
		FlashLocation = RealFlashLocation;
	}
	else
	{
		Super.ClearFlashLocation(InWeapon);
	}
}

/**
 * Drop our alternate weapon
 *
 * @param DamageType - Which damage type is causing a weapon drop
 */
function DropExtraWeapons(class<DamageType> DamageType)
{
	if (bAllowInventoryDrops && AltWeapon != None)
	{
		DropExtraWeapons_Worker(DamageType, AltWeapon.DroppedWeaponClass);
	}
}

/**
 * Don't allow chainsawing
 *
 * @param Attacker - Which pawn would like to special melee us
 */
simulated function bool CanBeSpecialMeleeAttacked( GearPawn Attacker )
{
	return FALSE;
}

/**
 * Reduce bullet damage if not screaming headshots
 *
 * @param Damage - the damage being dealt to this pawn
 * @param InstigatedBy - the pawn hitting us
 * @param HitLocation - where the damage occurred
 * @param Momentum - the momentum the damage will apply
 * @param GearDamageType - the type of damage incoming
 * @param HitInfo - misc info about the damage event
 */
function AdjustPawnDamage( out int Damage, Pawn InstigatedBy, vector HitLocation, out vector Momentum,
				class<GearDamageType> GearDamageType, Actor DamageCauser, optional out TraceHitInfo HitInfo )
{
	// Block part of ballistic damage if not on weak spot.
	if (GearDamageType != class'GDT_HeavySniperRifle' && ClassIsChildOf(GearDamageType, class'GDT_Ballistic'))
	{
		if (!IsScreaming() || !TookHeadShot(HitInfo.BoneName, HitLocation, Momentum))
		{
			BlockedShotDamageAmount += Damage;

			if (BlockedShotDamageAmount > BlockedShotLaughThreshold && !IsScreaming() && `TimeSince(LastLaughTime) > LaughFrequency)
			{
				LastLaughTime = WorldInfo.TimeSeconds;
				PlaySound(BlockedShotLaugh);
				BlockedShotDamageAmount = 0;
			}

			Damage = Max(Damage / BlockedShotDamageReductionFactor, 1);
			HitInfo.PhysMaterial = BlockedShotPhysMat;
		}
	}

	Super.AdjustPawnDamage(Damage, InstigatedBy, HitLocation, Momentum, GearDamageType, DamageCauser, HitInfo);
}

/** Tells us if head is currently vulnerable */
simulated final function bool HeadVulnerable(Name InBoneName)
{
	return (IsScreaming() && (InBoneName == HeadBoneNames[0]));
}

/** Reticule Plus for vulnerable head */
simulated function bool ShouldDisplayCrosshairPlus(GearPC PC, vector HitLocation, Name HitBone, PrimitiveComponent HitComponent)
{
	if( HeadVulnerable(HitBone) )
	{
		return TRUE;
	}

	return Super.ShouldDisplayCrosshairPlus(PC, HitLocation, HitBone, HitComponent);
}

/** Cause pain and head cover instead of knocking down */
function DoKnockDown()
{
	local int i;
	local GearPawn FoundPawn;
	local int ScreamDamage;
	local float DistFromScream;

	if (Role == ROLE_Authority)
	{
		for (i = 0; i < PawnsToKnockDown.length; i++)
		{
			FoundPawn = PawnsToKnockDown[i];
			DistFromScream = VSize(FoundPawn.Location - Location);

			ScreamDamage = GetRangeValueByPct(ScreamDamageRange, DistFromScream / KnockdownRange);

			if( ScreamDamage > 0 )
			{
				FoundPawn.TakeDamage(ScreamDamage, Controller, FoundPawn.LocationOfLastBloodTrail, vect(0,0,-1), class'GDT_Melee');
			}

// 			FoundPawn.SetLocation(FoundPawn.Location + vect(0,0,10.0));
// 			FoundPawn.SetPhysics(PHYS_Falling);
// 			FoundPawn.Velocity = Normal(FoundPawn.Location - Location) * 800.0;
// 			FoundPawn.Velocity.z += 100.0;
		}

		LastSuccessfulKnockdownTime = WorldInfo.TimeSeconds;
	}
}

exec function PlayHeadCoverAnim(float DurationSec, optional bool bDisableRoadieRun)
{
	// override to do explosive damage reaction
	if (!IsDoingASpecialMove() || SpecialMoves[SpecialMove].CanOverrideMoveWith(SM_StumbleGoDown))
	{
		ServerDoSpecialMove(SM_StumbleGoDown);
		SetTimer(1.0, false, nameof(GetBackUpFromKnockDown));
	}
}

/**
 * Don't play any hit reactions
 *
 * @param Impact - misc info about the hit
 *
 * @return FALSE to indicate no anims were played
 */
simulated function bool PlayHitReactionAnimation(ImpactInfo Impact)
{
	return FALSE;
}

/** @return FALSE, the Armored Kantus is not a wuss */
simulated function bool PlayNearMissCringe()
{
	return FALSE;
}

/**
 * Torque bow can only pierce during screaming
 *
 * @param Proj - the projectile hitting us
 * @param HitInfo - misc info about the hit
 * @param HitLocation - where the arrow hit us
 * @param Momentum - the momentum of the arrow
 * @param out_bHasHelmet - whether we're still wearing a helmet
 */
simulated function bool ShouldTorqueBowArrowGoThroughMe(GearProjectile Proj, TraceHitInfo HitInfo, vector HitLocation, vector Momentum, optional out byte out_bHasHelmet)
{
	if (!IsScreaming())
	{
		return FALSE;
	}

	return Super.ShouldTorqueBowArrowGoThroughMe(Proj, HitInfo, HitLocation, Momentum, out_bHasHelmet);
}

// don't override
simulated function ParticleSystem GetImpactOverrideParticleSystem();

/**
 * Char up the alt weapon
 *
 * @param CharIncrement - how much char to add
 */
simulated function CharSkin(float CharIncrement)
{
	Super.CharSkin(CharIncrement);

	if (AltWeapon != None && AltWeapon.MIC_WeaponSkin != None && AltWeapon.Mesh.bAttached)
	{
		AltWeapon.MIC_WeaponSkin.SetScalarParameterValue('Burn', CurrentSkinChar);
	}
}

/**
 * Heat up the alt weapon
 *
 * @param HeatIncrement - how much heat to add
 */
simulated function HeatSkin(float HeatIncrement)
{
	Super.HeatSkin(HeatIncrement);

	if (AltWeapon != None && AltWeapon.MIC_WeaponSkin != None && AltWeapon.Mesh.bAttached)
	{
		AltWeapon.MIC_WeaponSkin.SetScalarParameterValue('Heat', CurrentSkinHeat);
	}
}

function bool ShouldOtherEvadeMeInsteadOfMeleeing(GearPawn Other)
{
	return true;
}

simulated function Mouth_Open()
{
	SetMouthGlowPS(TRUE);
	SetMouthGlowLensFlare(TRUE);
	MIC_PawnMat.SetScalarParameterValue('Mouth_Glow', 1);
}

simulated function Mouth_Close()
{
	SetMouthGlowPS(FALSE);
	SetMouthGlowLensFlare(FALSE);
	MIC_PawnMat.SetScalarParameterValue('Mouth_Glow', 0);
}

simulated final function SetMouthGlowLensFlare(bool bActive)
{
	if( MouthGlowFlareComp == None && MouthGlowLF != None )
	{
		MouthGlowFlareComp = new(self) class'LensFlareComponent';
		MouthGlowFlareComp.SetTemplate(MouthGlowLF);
	}

	if( MouthGlowFlareComp != None )
	{
		MouthGlowFlareComp.SetIsActive( bActive );
	}
}

simulated final function SetMouthGlowPS(bool bActive)
{
	if( MouthGlowPSC == None && MouthGlowPS != None )
	{
		MouthGlowPSC = new(self) class'ParticleSystemComponent';
		MouthGlowPSC.SetTemplate( MouthGlowPS );
		MouthGlowPSC.bAutoActivate = FALSE;
		Mesh.AttachComponentToSocket(MouthGlowPSC, 'Glow');
	}

	if( MouthGlowPSC != None )
	{
		MouthGlowPSC.SetActive( bActive );
	}
}

defaultproperties
{
	SkinHeatFadeTime=3.f
	bCanPlayPhysicsHitReactions=FALSE

	ControllerClass=class'GearAI_KantusArmor'

	SpecialMoveClasses(SM_FullBodyHitReaction)=None
	SpecialMoveClasses(SM_CoverHead)=None

	LastFireTime=-10.0f

	NoticedGUDSPriority=150
	NoticedGUDSEvent=GUDEvent_NoticedKantusArmor
	SiegeTutorialType=GEARTUT_SIEGE_ArmoredKantus

	CharacterFootStepType=CFST_Locust_ArmoredKantus
}
