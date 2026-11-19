/**
 * Cleaver weapon base class
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeap_CleaverBase extends GearWeap_HeavyBase
	abstract
	native(Weapon);

/** Save projectile location before the special move starts */
var protected vector ProjLoc;

/** Save projectile direction before the special move starts */
var protected vector ProjDir;

/** The delay to throw the cleaver after the throw animation has started */
var config const float ProjectileSpawnTime;

/** The arc that the cleaver swipe should damage in radians */
var config const float DamageArc;

/** The arc that the cleaver swipe should damage in radians while in cover */
var config const float DamageArcInCover;

/** The damage radius caused by the cleaver swipe */
var config const float SwipeRadius;

/** The damage radius caused by the cleaver swipe while in cover */
var config const float SwipeRadiusInCover;

/** The delay to cause damage after the swipe animation has started */
var config const float SwipeFireDelay;

/** Save the swipe location before the special move starts */
var protected vector SwipeLoc;

/** Sound to play while bringing the cleaver up for targeting */
var SoundCue LiftSound;

/** Whether a pawn was successfully hit this swing */
var bool bHitPawnThisSwing;

/** Arm/Twist bones are looking bad when targetted with Cleaver so we need to disable them**/
var SkelControl_TwistBone LeftArm;
var SkelControl_TwistBone RightArm;
var SkelControl_TwistBone ForeLeftTwist;
var SkelControl_TwistBone ForeRightTwist;

/** The break effect particles */
var class<ReplicatedSpawnedGearEmitter> BreakEffectClass;

/** Previous Instigator who trigger fire **/
var transient GearPawn OldInstigator;

/** Spawned projectile **/
var transient GearProj_CleaverBase SpawnedProjectile;

/** Cleaver Mesh **/
var transient SkeletalMeshComponent CleaverMesh;

/** Limit Pitch view when targetting - we don't have animation for different pitches **/
var() const config int				PitchLimitMin;
var() const config int				PitchLimitMax;

cpptext
{
	virtual UBOOL DisableAimOffset();
}

// Cache Cleaver Mesh, so that I don't have to cache everytime
simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	// save cleaver mesh
	CleaverMesh = SkeletalMeshComponent(Mesh);
}

/** Cache aiming location and rotation then kick off the throw special move if targeting, just swipe otherwise */
simulated function CustomFire()
{
	local GearPawn GP;

	GP = GearPawn(Instigator);
	if (GP != None)
	{
		if (GP.bIsTargeting)
		{
			Super.GetProjectileFirePosition(ProjLoc, ProjDir);

			// Start the timer that will cause the projectile spawn.
			SetTimer(ProjectileSpawnTime, FALSE, nameof(ProjectileFire));

			// Play the cleaver throwing animation on the pawn
			GP.DoSpecialMove(SM_CleaverThrow);
		}
		else
		{
			GP.DoSpecialMove(SM_CleaverSwipe);
		}
	}

	super.CustomFire();
}

/**
 * DoSwipeFire found a hit, now cause damage to it.
 *
 * @param A - the actor that was hit in the swipe
 */
simulated function ProcessSwipeHit(Actor A, vector InHitLoc, vector InHitNorm, TraceHitInfo InHitInfo)
{
	local PrimitiveComponent Primitive;
	local ImpactInfo Impact;
	local TraceHitInfo HitInfo;
	local vector HitLocation, HitNormal, TraceEnd;
	local GearPawn GP;

	// extend end point, so that it has more chance to hit
	TraceEnd = InHitLoc - InHitNorm*50;

	// check that we actually hit the thing and generate hit info
	Impact.HitActor = A;
	Impact.RayDir = Normal(A.Location - TraceEnd);
	Impact.StartTrace = SwipeLoc;
	Impact.HitLocation = InHitLoc;
	Impact.HitNormal = InHitNorm;
	Impact.HitInfo = InHitInfo;
	// Trace line
	//DrawDebugLine(SwipeLoc, TraceEnd, 255, 255, 0, TRUE);

	// more precise location info if it has primitives
	// if it's cover, they don't get primitive component
	foreach A.AllOwnedComponents(class'PrimitiveComponent', Primitive)
	{
		// need extension. Otherwise miss too easy
		if ( Primitive.CollideActors && Primitive.BlockZeroExtent &&
			A.TraceComponent(HitLocation, HitNormal, Primitive, TraceEnd, SwipeLoc,vect(30,30,30), HitInfo) )
		{
			Impact.HitLocation = HitLocation;
			Impact.HitNormal = HitNormal;
			Impact.HitInfo = HitInfo;
			break;
		}
	}
	GP = GearPawn(Impact.HitActor);
	if (GP != None && !GP.bPlayedDeath && !GP.InGodMode() && !GP.IsSameTeam(GearPawn(Instigator)))
	{
		bHitPawnThisSwing = TRUE;
	}

	//DrawDebugLine(SwipeLoc, Impact.HitLocation, 0, 0, 255, TRUE);

	if (Role == ROLE_Authority || bClientSideInstantHit)
	{
		// Set flash location to trigger client side effects.
		// if HitActor == None, then HitLocation represents the end of the trace (maxrange)
		// Remote clients perform another trace to retrieve the remaining Hit Information (HitActor, HitNormal, HitInfo...)
		// Here, The final impact is replicated. More complex bullet physics (bounce, penetration...)
		// would probably have to run a full simulation on remote clients.
		SetFlashLocation(Impact.HitLocation);
	}

	ProcessInstantHit(0, Impact, 1);

	// Make the hit actor stumble, bPlayedDeath may have been changed by ProcessInstantHit
	if (GP != None && Role == ROLE_Authority && bHitPawnThisSwing && !GP.bPlayedDeath)
	{
		GP.DoStumbleFromMeleeSpecialMove( GearPawn(Instigator) );
	}
}

/** The server can have an extra swing animation to look fluid, the client should tell the server when it is actually swinging */
simulated function DoSwipeFire()
{
	local Actor A;
	local GearPawn GP;
	local vector BreakLoc, BladeStart, BladeEnd, NewSwipeLoc, Extent, HitLoc, HitNorm;
	local TraceHitInfo HitInfo;

	bHitPawnThisSwing = FALSE;
	
	// get socket location where blades are right now
	CleaverMesh.GetSocketWorldLocationAndRotation('BladeStart', BladeStart);
	CleaverMesh.GetSocketWorldLocationAndRotation('BladeEnd', BladeEnd);
	NewSwipeLoc = BladeEnd;
	Extent.X = VSize(BladeStart-BladeEnd);
	Extent.Y = Extent.X;
	Extent.Z = Extent.X;

	//DrawDebugLine(SwipeLoc, NewSwipeLoc, 255, 0, 0, true);

	foreach Instigator.TraceActors(class'Actor', A, HitLoc, HitNorm, NewSwipeLoc, SwipeLoc, Extent, HitInfo )
	{
		// when you hit covers, it will show as worldinfo but with precise hitlocation info
		// so allow them to go through so that you can hit cover fine. 
		if ( A != Instigator )
		{
			// extend it, sometimes it doesn't hit there, need to extent trace point to -HitNormal
			ProcessSwipeHit(A, HitLoc, HitNorm, HitInfo);
		}
	}

	// only owner calls ammo consume
	if (bNetOwner && bHitPawnThisSwing)
	{
		// Use up some ammo, have to call the super since we stubbed out the call below.
		Super.ConsumeAmmo(0);
	}

	// If we're out of ammo, toss the weapon
	GP = GearPawn(Instigator);
	if (Role == ROLE_Authority && GP != None && !HasAnyAmmo())
	{
		// spawn the replicated emitter
		SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation('Break2', BreakLoc);
		Spawn(BreakEffectClass,,, BreakLoc);

		GP.ServerEndSpecialMove();
		GP.TossInventory(Self);
		GearInventoryManager(GP.InvManager).AutoSwitchWeapon();
	}
}

simulated function CalcRemoteImpactEffects( byte FireModeNum, vector GivenHitLocation, bool bViaReplication )
{
	local Actor A;
	local vector   Extent, HitLoc, HitNorm;
	local TraceHitInfo HitInfo;

	Extent = vect(50, 50, 50);

	//`log("CalcRemoteImpactEffects: "@GivenHitLocation);
	foreach Instigator.TraceActors(class'Actor', A, HitLoc, HitNorm, GivenHitLocation, SwipeLoc, Extent, HitInfo)
	{
		if ( A != Instigator && A.bCollideActors == TRUE )
		{
			// extend it, sometimes it doesn't hit there, need to extent trace point to -HitNormal
			ProcessSwipeHit(A, HitLoc, HitNorm, HitInfo);
		}
	}
}
/**
 * Get Projectile Spawn Location and Direction.
 *
 * @param out_ProjLoc - The projectile location to return.
 *
 * @param out_ProjDir - The projectile direction to return.
 *
 */
simulated function GetProjectileFirePosition( out vector out_ProjLoc, out vector out_ProjDir, optional out float out_ProjSpeed )
{
	out_ProjDir = ProjDir;

	// Get Bone name of b_MF_Weapon_R_End and use that location
	// that is where weapon is in the animation
	out_ProjLoc = Instigator.Mesh.GetBoneLocation('b_MF_Weapon_R_End');
}

/**
 * Throw the cleaver, remove the weapon from inventory and switch to the best weapon
 *
 * @return the spawned projectile
 */
simulated function Projectile ProjectileFire()
{
	OldInstigator = GearPawn(Instigator);

	if (OldInstigator == None || !OldInstigator.IsDoingSpecialMove(SM_CleaverThrow))
	{
		return None;
	}

	SpawnedProjectile = GearProj_CleaverBase(Super.ProjectileFire());

	// hide mesh of weapon
	CleaverMesh.SetHidden(true);

	// replicate detaching cleaver
	DetachCleaver();

	//DrawDebugSphere(SpawnedProjectile.Location, 10, 10, 0, 255, 0, true );
	//DrawDebugLine(SpawnedProjectile.Location, SpawnedProjectile.Location + 1200 * Normal(SpawnedProjectile.Velocity), 0, 255, 0, true );

 	if (SpawnedProjectile != none)
 	{
 		SpawnedProjectile.Inventory = Self;
 	}

	return SpawnedProjectile;
}

simulated state MeleeAttacking
{
	/**
	 *  Override the melee state so it causes the swipe special move.
	 *
	 *  @param PreviousStateName - the name of the previous state
	 */
	simulated function BeginState(Name PreviousStateName)
	{
		local GearPawn GP;

		bCheckedKickThisAttack = TRUE;

		// If we're supposed to kick, skip the swing
		if (ShouldMeleeKick())
		{
			bKickThisAttack = TRUE;
			Super.BeginState(PreviousStateName);
		}
		else
		{
			GP = GearPawn(Instigator);
			if (GP != none)
			{
				GP.DoSpecialMove(SM_CleaverSwipe);
			}

			EndFire(MELEE_ATTACK_FIREMODE);
			// we're done, leave state and go back to active
			GotoState('Active');
		}
	}
}

/** Refresh Skel Controls for arm rolling/twist bones **/
simulated function RefreshSkelControls()
{
	local GearPawn GP;

	GP = GearPawn(Instigator);

	if (GP.EquippedCleaver == self)
	{
		// Cache these skel controls
		// To avoid cache for all pawns, we only cache these when equipping cleavers
		LeftArm = SkelControl_TwistBone(GP.Mesh.FindSkelControl('ArmRollL'));
		RightArm = SkelControl_TwistBone(GP.Mesh.FindSkelControl('ArmRollR'));
		ForeLeftTwist = SkelControl_TwistBone(GP.Mesh.FindSkelControl('ArmRollR'));
		ForeRightTwist = SkelControl_TwistBone(GP.Mesh.FindSkelControl('ArmRollR'));
	}
	else
	{
		// Turn them back on
		TurnOnTwistBones();

		LeftArm = none;
		RightArm = none;
		ForeLeftTwist = none;
		ForeRightTwist = none;
	}
}

/**
 * Play the lift sound when aiming
 *
 * @param P - the Pawn changing its targeting mode
 */
simulated function TargetingModeChanged(GearPawn P)
{
	if (P.bIsTargeting)
	{
		P.PlaySound(LiftSound);

		// turn off timer - if it's on, it will turn that on again
		ClearTimer('TurnOnTwistBones');

		// turn off all twist bones
		LeftArm.SetSkelControlActive(FALSE);
		RightArm.SetSkelControlActive(FALSE);
		ForeLeftTwist.SetSkelControlActive(FALSE);
		ForeRightTwist.SetSkelControlActive(FALSE);
	}
	else
	{
		// delay to turn it on
		// because otherwise, it will turn on when arms are high and it will look bad
		// delay until it comes down
		SetTimer(1.f, FALSE, 'TurnOnTwistBones');
	}

	Super.TargetingModeChanged(P);
}

/** Turn on Twist Bones **/
simulated function TurnOnTwistBones()
{
	LeftArm.SetSkelControlActive(TRUE);
	RightArm.SetSkelControlActive(TRUE);
	ForeLeftTwist.SetSkelControlActive(TRUE);
	ForeRightTwist.SetSkelControlActive(TRUE);
}

/**
 * Block the heavy weapons system from dropping us on melee
 *
 * @return TRUE to allow melee
 */
simulated function bool CanDoSpecialMeleeAttack()
{
	return TRUE;
}

/**
 * Don't consume ammo through the normal weapon codepath because it would cause inconsistencies since we only want to expend ammo on good hits
 *
 * @param FireModeNum - the firing mode the weapon is in
 */
simulated function ConsumeAmmo(byte FireModeNum);

/** Called by AttachWeaponTo to perform weapon attachment after we're sure it's ok to do so. */
simulated function PerformWeaponAttachment(SkeletalMeshComponent MeshCpnt, optional Name SocketName)
{
	local GearPawn GP;

	Super.PerformWeaponAttachment( MeshCpnt, SocketName );

	GP = GearPawn(MeshCpnt.Owner);

	// cleaver is originally designed for boomer, so it has wrong rotation
	// so need to adjust it when attached
	if (GearPawn_LocustBoomerBase(GP)!=none)
	{
		Mesh.SetRotation(MakeRotator(0, 0, 0));
	}
	else if (ShouldWeaponBeMirrored(GP))
	{
		Mesh.SetRotation(MakeRotator(0, 16384, 0));
	}
	else
	{
		Mesh.SetRotation(MakeRotator(0, -16384, 0));
	}

	GP = GearPawn(Instigator);

	if (GP != None)
	{
		GP.EquippedCleaver = Self;
		RefreshSkelControls();
	}
}

/** Let the instigator know that a cleaver is no longer equipped */
simulated function DetachWeapon()
{
	local GearPawn GP;

	GP = GearPawn(Instigator);

	if (GP != None)
	{
		if (GP.EquippedCleaver == Self)
		{		
			GP.EquippedCleaver = None;
			RefreshSkelControls();
		}
	}

	Super.DetachWeapon();
}

/**
 * Don't draw a crosshair if in cover
 *
 * @return TRUE if a crosshair should be drawn
 */
simulated function bool ShouldDrawCrosshair()
{
	if (GearPawn(Instigator) != None && GearPawn(Instigator).IsInCover())
	{
		return FALSE;
	}

	return Super.ShouldDrawCrosshair();
}

// limit view rotation when targetting
simulated function ProcessViewRotation( float DeltaTime, out rotator out_ViewRotation, out Rotator out_DeltaRot )
{
	local GearPawn GP;

	GP = GearPawn(Instigator);
	if (GP != None)
	{
		// if targetting, clamp
		// otherwise, animation does not support low/high throw
		// so it looks bad
		if (GP.bIsTargeting)
		{
			out_ViewRotation.Pitch	= ClampRotAxisFromRange(out_ViewRotation.Pitch, PitchLimitMin, PitchLimitMax);
		}
	}

	Super.ProcessViewRotation( DeltaTime, out_ViewRotation, out_DeltaRot );
}

// if projectile has been spanwed, don't drop. 
function DropFrom(vector StartLocation, vector StartVelocity)
{
	// if i fired out, do not drop from
	if ( SpawnedProjectile == none )
	{
		Super.DropFrom(StartLocation, StartVelocity);
	}
}

// Save Swipe Location
simulated function SaveSwipeLocation()
{
	CleaverMesh.GetSocketWorldLocationAndRotation('BladeEnd', SwipeLoc);
}

/** Return TRUE to prevent targeting */
simulated function bool ShouldPreventTargeting()
{
	local GearPawn GP;

	GP = GearPawn(Instigator);
	// when in cover, don't let them target
	if (GP!=none && GP.CoverType != CT_None && GP.CurrentLink  != none)
	{
		return TRUE;
	}

	return Super.ShouldPreventTargeting();
}

/** @see Weapon::ShouldRefire() */
simulated function bool ShouldRefire()
{
	local GearPawn GP;

	GP = GearPawn(Instigator);

	// if swipe, he's still firing, do not turn off fire yet
	if (GP!=none && GP.SpecialMove == SM_CleaverSwipe)
	{
		return TRUE;
	}

	return Super.ShouldRefire();
}

/** Detach cleaver mesh from pawn's hand when throwing it or attaching it somewhere */
simulated function DetachCleaver()
{
	`LogInv("");
	// Use SetFlashLocation as a way to replicate this
	SetFlashLocation(VRand()*100);
}

simulated function FlashLocationUpdated(byte FiringMode, vector FlashLocation, bool bViaReplication)
{
	local GearPawn GP;
	GP = GearPawn(Instigator);

	// we override FlashLocation to indicate melee hits
	if( GP!=none && GP.SpecialMove == SM_CleaverThrow && !IsZero(FlashLocation) )
	{
		// hide mesh and deetach it
		CleaverMesh.SetHidden(TRUE);
		DetachWeapon();
	}
}

simulated static function ParticleSystem GetImpactOverrideParticleSystem(ImpactInfo Hit)
{
	if ( GearPawn(Hit.HitActor)!=none )
	{
		// if gear pawn
		return ParticleSystem'Effects_Gameplay.Blood.P_Bucher_Slash';
	}

	return none;
}

defaultproperties
{
	WeaponStatName="Cleaver"

	bAllowsRoadieRunning=true
	bUseHeavySkelControl=false
	bAllowDownsightsStance=true
	bUseHeavyWeaponSpeedMods=false
	bAIAvoidsTaking=true

	// Weapon Animation
	Begin Object Class=AnimNodeSequence Name=WeaponAnimNode
		AnimSeqName=""
	End Object

	WeaponFireAnim=""

	FireOffset=(X=66,Z=20.0)

	bDisableLeftHandIK=true

	WeaponFireTypes(DEFAULT_FIREMODE)=EWFT_Custom
	InstantHitDamageTypes(DEFAULT_FIREMODE)=class'GDT_CleaverMelee'

	FiringStatesArray(MELEE_ATTACK_FIREMODE)="MeleeAttacking"
	WeaponFireTypes(MELEE_ATTACK_FIREMODE)=EWFT_InstantHit
	InstantHitDamageTypes(MELEE_ATTACK_FIREMODE)=class'GDT_CleaverMelee'

	// allow all direction
	AllowedViewDotHitDir = -1.f
}
