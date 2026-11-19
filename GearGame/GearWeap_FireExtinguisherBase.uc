/**
 * Fire extinguisher weapon
 *
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearWeap_FireExtinguisherBase extends GearWeap_HeavyBase
	config(Weapon);

/** Particles to play when spraying is on */
var ParticleSystemComponent SprayPSC;

/** Whether we're spraying */
var bool bSpraying;

/** Component to hold the fire sound loop */
var AudioComponent FireLoopAC;

/** Sound to play when firing stops */
var SoundCue StartFireSound;

/** How much damage to cause to the extinguished object */
var config float ExtinguishDamage;

/** How far away from the muzzle should the extinguish damage be */
var config float ExtinguishDist;

/** How often to cause ExtinguishDamage */
var config float ExtinguishInterval;

/** Skel Control to place handle to player hand */
var transient SkelControlSingleBone HandLocator;

/** transient handle offset - instead of using socket, going for this approach **/
var transient matrix HandleOffset;

/** @return FALSE since we can never pick up ammo */
simulated function bool CanPickupAmmo()
{
	return FALSE;
}

/** Drop the fire extinguisher instead of putting it down */
simulated function PutDownWeapon()
{
	// Make sure all pending fires are cleared.
	ForceEndFire();

	// Put weapon to sleep
	//@warning: must be before ChangedWeapon() because that can reactivate this weapon in some cases
	GotoState('Inactive');

	// Throw weapon
	Instigator.ThrowActiveWeapon();

	// Switch to pending weapon
	InvManager.ChangedWeapon();
}

/** Turn on the spray */
simulated protected function TurnOnSpray()
{
	if (!bSpraying)
	{
		PlayFireSound();
		SprayPSC.ActivateSystem();

		bSpraying = TRUE;
	}
}

/** Turn off the spray */
simulated protected function TurnOffSpray()
{
	SprayPSC.DeactivateSystem();

	bSpraying = FALSE;

	StopFireLoopingAudio();

	ClearTimer(nameof(ExtinguishFire));
}

/** Mount the spray particle */
simulated function PostBeginPlay()
{
	local SkeletalMeshComponent SMC;
	Super.PostBeginPlay();

	SMC = SkeletalMeshComponent(Mesh);
	SMC.AttachComponentToSocket(SprayPSC, 'Muzzle');

	/** This used to be socket in Marcus, but either we have to add socket to all pawn for this or just use this fixed offset and apply to all pawn **/
	/** The original socket is FireExtinguisherHolder in Marcus **/
	HandleOffset = MakeRotationTranslationMatrix(vect(8.567999,1.534781,5.037072), MakeRotator(-16384, 0, 0));
}

/** Play the spray sound */
simulated protected function PlayFireSound()
{
	if (FireLoopAC == None || !FireLoopAC.IsPlaying())
	{
		GearWeaponPlaySoundLocal(StartFireSound);

		// start loop
		FireLoopAC = GearWeaponPlaySoundLocalEx(FireSound,,, FireLoopAC);
		if (FireLoopAC != None)
		{
			FireLoopAC.bStopWhenOwnerDestroyed = TRUE;
		}
	}

	// Maybe alert AI of the noise
	if (WorldInfo.Netmode != NM_Client && Instigator != None)
	{
		Instigator.MakeNoise(1.f, 'PlayFireSound');
	}
}

/** Stop the fire loop and play the stop fire sound */
simulated protected function StopFireLoopingAudio()
{
	if (FireLoopAC != None)
	{
		FireLoopAC.FadeOut(0.1f, 0.f);
		FireLoopAC = None;
	}

	if (IsFiring() || (bSlaveWeapon && !IsInState('WeaponEquipping')))
	{
		GearWeaponPlaySoundLocal(StopFireSound);
	}
}

simulated state WeaponFiring
{
	/**
	 * Turn on the spray
	 *
	 * @param PreviousStateName - the name of the previous state
	 */
	simulated function BeginState(Name PreviousStateName)
	{
		TurnOnSpray();
		Super.BeginState(PreviousStateName);
	}

	/**
	 * Leaving state, shut everything down
	 *
	 * @param NextStateName - the name of the next state
	 */
	simulated function EndState(Name NextStateName)
	{
		if (bSpraying)
		{
			TurnOffSpray();
		}
		ClearFlashLocation();
		ClearTimer('RefireCheckTimer');
		ClearPendingFire(0);

		super.EndState(NextStateName);
	}
}

/**
 * Enable and disable the spray for remote players
 *
 * @param FiringMode - the current firing mode
 *
 * @param FlashLocation - the spot that bullet hit
 *
 * @param bViaReplication - whether this was replicated over the network or not
 */
simulated function FlashLocationUpdated(byte FiringMode, vector FlashLocation, bool bViaReplication)
{
	if ((bSlaveWeapon || WorldInfo.IsPlayingDemo() || !bNetOwner) && bViaReplication)
	{
		if (IsZero(FlashLocation))
		{
			TurnOffSpray();
		}
		else if (FiringMode == 0)
		{
			if (!bSpraying)
			{
				TurnOnSpray();
			}
		}
	}

	Super.FlashLocationUpdated(FiringMode, FlashLocation, bViaReplication);
}

/** Start extinguishing the fire */
simulated function CustomFire()
{
	if (!IsTimerActive(nameof(ExtinguishFire)))
	{
		SetFlashLocation(vect(1,1,1));
		ExtinguishFire();
	}
}

/** Pick a point half of the extinguish distance away from the muzzle and do radius damage */
function ExtinguishFire()
{
	local vector HitCenter;
	local vector MuzzleLoc;
	local rotator MuzzleRot;
	local Actor Victim;
	local TraceHitInfo HitInfo;

	SetTimer(ExtinguishInterval, TRUE, nameof(ExtinguishFire));

	SkeletalMeshComponent(Mesh).GetSocketWorldLocationAndRotation('Muzzle', MuzzleLoc, MuzzleRot);

	HitCenter = MuzzleLoc + (ExtinguishDist / 2.0f) * vector(MuzzleRot);

	//DrawDebugSphere(HitCenter, ExtinguishDist / 2.0f, 10, 255, 0, 0, TRUE);

	// PLK - this doesn't work with the way Warren has things set up in Raven's Nest since InterpActors can't be HurtRadius'd
	//HurtRadius(ExtinguishDamage, ExtinguishDist / 2.0f, class'GDT_FireExtinguisherSpray', 2.0f, HitCenter,,, TRUE);

	foreach VisibleCollidingActors(class'Actor', Victim, ExtinguishDist / 2.0f, HitCenter,,,,, HitInfo )
	{
		if (!Victim.bWorldGeometry)
		{
			Victim.TakeDamage(ExtinguishDamage, Instigator.Controller, Victim.Location, vect(0,0,1), class'GDT_FireExtinguisherSpray');
		}
	}
}

simulated function Tick(float DeltaTime)
{
	local SkeletalMeshComponent WeaponMesh;
	local matrix BoneMatrix;

	// put handle on the left hand
	Super.Tick( DeltaTime );

	WeaponMesh = SkeletalMeshComponent(Mesh);
	if (HandLocator == none)
	{
		HandLocator = SkelControlSingleBone(WeaponMesh.FindSkelControl('Handle'));
	}

	if ( HandLocator!=none && Instigator!=none && Instigator.Mesh!=none )
	{
		// now need to find left hand, and leave handle there
		//Instigator.Mesh.GetSocketWorldLocationAndRotation('FireExtinguisherHolder', HandLocation, HandRotation);
		BoneMatrix = Instigator.Mesh.GetBoneMatrix(Instigator.Mesh.MatchRefBone('b_MF_Weapon_L_End'));
		BoneMatrix = HandleOffset * BoneMatrix;
		HandLocator.bApplyRotation = TRUE;
		HandLocator.bApplyTranslation = TRUE;

		HandLocator.BoneRotationSpace = BCS_WorldSpace;
		HandLocator.BoneRotation = MatrixGetRotator(BoneMatrix);
		HandLocator.BoneTranslation = MatrixGetOrigin(BoneMatrix);
	}
}

defaultproperties
{
	WeaponFireTypes(0)=EWFT_Custom

	bInfiniteSpareAmmo=false

	bWeaponCanBeReloaded=false

	WeaponType=WT_Heavy

	bCanSelectWithoutAmmo=false
	DamageTypeClassForUI=class'GDT_FireExtinguisherSpray'
	bCanActiveReload=false
	bAIAvoidsTaking=true
}
