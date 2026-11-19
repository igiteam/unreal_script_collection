
/**
 * Grenade flail used by the player
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */

class GearWeap_HeavyFlailBase extends GearWeap_HeavyBase
	native(Weapon)
	abstract;

/** Constraints to prevent flail chain from extending beyond its length. */
var()	editinline export	RB_ConstraintSetup		ChainLengthConstraintSetup;
var()	editinline export	RB_ConstraintInstance   ChainLengthConstraintInstance;
var()	editinline export	RB_BodyInstance			ChainEndBodyInstance;

var float	ChainEndSpringPctTarget;
var float	ChainEndSpringPct;
var float	ChainEndSpringBlendTimeToGo;

/** Defines the explosion. */
var() instanced editinline GearExplosion	ExplosionTemplate;

/** Amount of damage done at the epicenter. Using this instead of Projectile.Damage so we can make it config. */
var() protected const config float ExploDamage;
/** Damage range.  Using this instead of Projectile.DamageRadius so we can make it config. */
var() protected const config float ExploDamageRadius;
/** Defines how damage falls off.  High numbers cause faster falloff, lower (closer to zero) cause slower falloff.  1 is linear. */
var() protected const config float ExploDamageFalloffExp;

/** radius at which people will be knocked down/ragdolled by the projectile's explosion **/
var() protected const config float	ExploKnockDownRadius;
/** Radial knockdown strength **/
var() protected const config float	ExploKnockDownStrength;
/** radius at which people will cringe from the explosion **/
var() protected const config float	ExploCringeRadius;

/** Sound of chain during swing */
var SoundCue ChainAttackRattleSoundCue;
/** Sound of chain during lift effort */
var SoundCue ChainLiftSoundCue;

/**  Time since last heavy up/down effort played */
var float LastHeaveSoundTime;

simulated state WeaponFiring
{
	/** @see GearWeapon::ShouldRefire() */
	simulated function bool ShouldRefire()
	{
		local Controller PawnController;
		// For Players: It is not possible to refire. You have to release and re-press fire to shot every time
		PawnController = GetWeaponController();
		if( Instigator != None && Instigator.IsHumanControlled(PawnController) )
		{
			EndFire( CurrentFireMode );
			GetWeaponController().bFire = 0;

			return FALSE;
		}

		return Global.ShouldRefire();
	}

	simulated function bool TryPutdown()
	{
		bWeaponPutDown = true;
		return false;
	}

	simulated function StartFire(byte FireModeNum)
	{
		local GearPawn_Infantry	InfantryPawn;
		InfantryPawn = GearPawn_Infantry(Instigator);
		if( InfantryPawn != None && InfantryPawn.IsDoingSpecialMove(SM_FlailSmashAttack) == FALSE)
		{
			Super.StartFire(FireModeNum);
		}
		else
		{
			// no firing in this state.  make player repress trigger.
			EndFire( CurrentFireMode );
			GetWeaponController().bFire = 0;
		}
	}
};

/** Called from an anim notify. */
simulated function NotifyFlailImpact()
{
	local vector ExploLoc, HitLocation, HitNormal;

	ExploLoc = SkeletalMeshComponent(Mesh).GetBoneLocation('b_Flail_ChainEnd');
	// make sure flail didn't penetrate floor
	if (Instigator.Trace(HitLocation, HitNormal, ExploLoc, ExploLoc + vect(0,0,100), false) != None)
	{
		ExploLoc = HitLocation;
	}

	CauseFlailExplosion(ExploLoc, vect(0,0,1));
}

/**
 * Copy in any data we exposed here for .ini file access.
 */
simulated function PrepareExplosionTemplate()
{
	ExplosionTemplate.InitFromContentTemplate();
	ExplosionTemplate.Damage = ExploDamage;
	ExplosionTemplate.DamageRadius = ExploDamageRadius;
	ExplosionTemplate.DamageFalloffExponent = ExploDamageFalloffExp;
	ExplosionTemplate.KnockDownRadius = ExploKnockDownRadius;
	ExplosionTemplate.CringeRadius = ExploCringeRadius;
	ExplosionTemplate.CamShakeInnerRadius = ExploKnockDownRadius;
	ExplosionTemplate.CamShakeOuterRadius = ExploCringeRadius;
	ExplosionTemplate.CamShakeFalloff = ExploDamageFalloffExp;

	ExplosionTemplate.FractureMeshRadius = ExploKnockDownRadius;
}

simulated function CauseFlailExplosion(vector HitLocation, vector HitNormal)
{
	local vector NudgedHitLocation;
	local GearExplosionActor ExplosionActor;

	if (ExplosionTemplate != None)
	{
		// using a hitlocation slightly away from the impact point is nice for certain things
		NudgedHitLocation = HitLocation + (HitNormal * 4.f);

		ExplosionActor = Spawn(class'GearExplosionActor',,, NudgedHitLocation, rotator(HitNormal));
		PrepareExplosionTemplate();
		ExplosionTemplate.HitLocation = NudgedHitLocation;
		ExplosionTemplate.HitNormal = HitNormal;
		ExplosionTemplate.ActorToIgnoreForDamage = Instigator; //don't hurt yourself
		ExplosionActor.Explode(ExplosionTemplate);		// go bewm
	}
}

/** No melee with heavy weapons. */
simulated function bool CanDoSpecialMeleeAttack()
{
	return TRUE;
}

// hack to only allow fire in melee range
simulated function StartFire(byte FireModeNum)
{
    //One trick pony
	Super.StartFire( 0 );
}

simulated function CustomFire()
{
	// Trigger attack effects.
	IncrementFlashCount();
}

simulated function PlayFireEffects(byte FireModeNum, optional vector HitLocation)
{
	local GearPawn_Infantry	InfantryPawn;

	Super.PlayFireEffects(FireModeNum, HitLocation);

	// Play weapon fire animation. melee attack overhand.
	PlayWeaponAnim(WeaponFireAnim, 1.f, 0.5f, 0.5f);

    // Stop colliding with pawn swinging
	Mesh.SetRBCollidesWithChannel( RBCC_Pawn, FALSE );

	if (ChainAttackRattleSoundCue != None)
	{
		WeaponPlaySound(ChainAttackRattleSoundCue);
	}

	// Play synchronized attack animation on pawn.
	InfantryPawn = GearPawn_Infantry(Instigator);
	if (Role == ROLE_Authority && !bSlaveWeapon)
	{
		if( InfantryPawn != None && InfantryPawn.CanDoSpecialMove(SM_FlailSmashAttack))
		{
			InfantryPawn.ServerDoSpecialMove(SM_FlailSmashAttack, false, , class'GSM_Flail_Smash'.static.PackSpecialMoveFlags(InfantryPawn.bIsTargeting ? FST_Targeted : FST_Normal));
		}
	}

//	Moved to GSM_FlailSmash to get accurate timing from animation playing
// 	if( ChainEndBodyInstance != None )
// 	{
// 		SetChainEndBoneSpringTarget(5.f, class'GSM_Flail_Smash'.default.AimedSmashAnimLength * 0.5f);
// 		SetTimer( 1.0f, FALSE, nameof(TurnOffChainEndBoneSpring) );
// 	}
}

simulated function TurnOffChainEndBoneSpring()
{
	SetChainEndBoneSpringTarget(0.f, 0.2f);
	//Ok to collide again with holding pawn
	Mesh.SetRBCollidesWithChannel( RBCC_Pawn, TRUE );
}

simulated function TargetingModeChanged(GearPawn P)
{
	Super.TargetingModeChanged(P);

	//"throw" the chain out while lifting so it doesn't tangle on pawn
	SetChainEndBoneSpringTarget(1.f, 0.1f);
	SetTimer( 0.3f, FALSE, nameof(TurnOffChainEndBoneSpring) );

	//play effort
	if (WorldInfo.TimeSeconds - LastHeaveSoundTime > 1.0)
	{
		if (P.bIsTargeting)
		{
			//Play raise over hand sound
			P.SoundGroup.PlayEffort( P, GearEffort_BoloReleaseEffort, TRUE );
		}
		else
		{
			//Play put down sound
			P.SoundGroup.PlayEffort( P, GearEffort_BoloReleaseEffort, TRUE );
		}

		if (ChainLiftSoundCue != None)
		{
			WeaponPlaySound(ChainLiftSoundCue);
		}
	}

	//Makes sure that spamming the button doesn't play the sounds unnecessarily
	LastHeaveSoundTime = WorldInfo.TimeSeconds;
}

simulated function PerformWeaponAttachment(SkeletalMeshComponent MeshCpnt, optional Name SocketName)
{
	local SkeletalMeshComponent	SkelMesh;
	local int					FlailEndIndex;
	local matrix				FlailEndMatrix;

	Super.PerformWeaponAttachment(MeshCpnt, SocketName);

	// If weapon has been successfully attached, sync both flail spin animation, with boomer spinning animation.
	AnimTreeRootNode.ForceGroupRelativePosition('FlailSpin', GearPawn(Instigator).AnimTreeRootNode.GetGroupRelativePosition('FlailSpin') );

	SkelMesh = SkeletalMeshComponent(Mesh);

	//Adjust aim time params (lower the flail faster)
	GearPawn(Instigator).AimTimeAfterFiring = 0.0f;

	// Created physics asset instance.
	// Comment out to disable physics on flail.
	SkelMesh.SetHasPhysicsAssetInstance(TRUE);

	// Physics flail setup. Isolated for easy commenting out.
	if( SkelMesh.PhysicsAssetInstance != None )
	{
		// Setup max length constraint. To prevent chain from breaking at high velocity/torque
		ChainLengthConstraintInstance.InitConstraint(SkelMesh, SkelMesh, ChainLengthConstraintSetup, 1.f, Self, None, FALSE);

		// Add BoneSpring for FlailEnd body, so it tries to match the animation.
		SkelMesh.ForceSkelUpdate();
		FlailEndIndex	= SkelMesh.MatchRefBone('b_Flail_ChainEnd');
		FlailEndMatrix	= SkelMesh.GetBoneMatrix(FlailEndIndex);

		// Find the hip body instance
		ChainEndBodyInstance = SkelMesh.FindBodyInstanceNamed('b_Flail_ChainEnd');
		if( ChainEndBodyInstance != None )
		{
			ChainEndBodyInstance.EnableBoneSpring(TRUE, TRUE, FlailEndMatrix);
		}

		// Turn off bone spring by default.
		SetChainEndBoneSpringTarget(0.f, 0.f);
		UpdateChainEndBoneSpringValues();

		// Startup physics
		SkelMesh.PhysicsWeight = 1.f;
		SkelMesh.WakeRigidBody();
	}
}

simulated function Tick(float DeltaTime)
{
	local float Delta;

	Super.Tick(DeltaTime);

	if( ChainEndSpringPct != ChainEndSpringPctTarget )
	{
		Delta = ChainEndSpringPctTarget - ChainEndSpringPct;

		if( ChainEndSpringBlendTimeToGo > DeltaTime )
		{
			ChainEndSpringPct += (Delta / ChainEndSpringBlendTimeToGo) * DeltaTime;
			ChainEndSpringBlendTimeToGo -= DeltaTime;
		}
		else
		{
			ChainEndSpringPct = ChainEndSpringPctTarget;
			ChainEndSpringBlendTimeToGo	= 0.f;
		}

		UpdateChainEndBoneSpringValues();
	}
}

simulated function SetChainEndBoneSpringTarget(float NewTarget, float BlendTime)
{
	if( BlendTime > 0.f )
	{
		ChainEndSpringPctTarget = NewTarget;
		ChainEndSpringBlendTimeToGo = BlendTime;
	}
	else
	{
		ChainEndSpringPct = NewTarget;
		ChainEndSpringPctTarget = NewTarget;
		ChainEndSpringBlendTimeToGo = 0.f;
	}
}

simulated final function UpdateChainEndBoneSpringValues()
{
	if( ChainEndBodyInstance != None )
	{
		ChainEndBodyInstance.SetBoneSpringParams(ChainEndSpringPct, ChainEndSpringPct * 0.1f, ChainEndSpringPct, ChainEndSpringPct * 0.1f);
	}
}

/**
* Detach weapon components from Instigator. Perform any clean up.
*/
simulated function DetachWeapon()
{
	local SkeletalMeshComponent SkelMesh;

	//Adjust aim time params (back to normal)
	if (Instigator != None)
	{
	 	GearPawn(Instigator).AimTimeAfterFiring = GearPawn(Instigator).default.AimTimeAfterFiring;
	}

	//Turn off physics stuff
	SkelMesh = SkeletalMeshComponent(Mesh);
	SkelMesh.PhysicsWeight = 0.0f;
	SetChainEndBoneSpringTarget(0.0f, 0.0f);
	UpdateChainEndBoneSpringValues();
	SkelMesh.PutRigidBodyToSleep();

	Super.DetachWeapon();
}

simulated function ConsumeAmmo(byte FireModeNum)
{
	local int SpareAmmoUsed;

	Super.ConsumeAmmo(FireModeNum);

	// since we don't have a normal clip, draw directly from spare ammo until it is used up
	if (bInfiniteSpareAmmo)
	{
		AmmoUsedCount = 0;
	}
	else if (SpareAmmoCount > 0)
	{
		SpareAmmoUsed = Min(SpareAmmoCount, AmmoUsedCount);
		AmmoUsedCount -= SpareAmmoUsed;
		SpareAmmoCount -= SpareAmmoUsed;
	}
}

simulated function float GetWeaponRating()
{
	// AI doesn't pull it out till enemy is in range
	if ( !Instigator.IsHumanControlled() && GetWeaponController().Enemy != None &&
		VSize(Instigator.Location - GetWeaponController().Enemy.Location) > 1024.0 )
	{
		return 0.1;
	}
	else
	{
		return Super.GetWeaponRating();
	}
}

defaultproperties
{
	WeaponStatName="Flail"

	bUseHeavySkelControl=false
	bAllowIdleStance=true
	bAllowAimingStance=false
	bAllowDownsightsStance=true
	bUseTargetingCamera=false
	bNoAnimDelayFiring=true
	bAllowsRoadieRunning=TRUE

	bNeverMirrorThisWeapon=TRUE
}
