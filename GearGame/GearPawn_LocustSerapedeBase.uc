//=============================================================================
// LocustSerapedeBase
//
// Base class for locust serapede - contains functionality but no asset references
//
// Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
//=============================================================================
class GearPawn_LocustSerapedeBase extends GearPawn_LocustCreatureBase
	implements(Interface_AIAimLocationOverride)
	abstract
	native(Pawn)
	config(Pawn);

/** list of bones that make up the segments of the tail */
var() array<name> TailBoneNames;

/** list of bone names to attach giblets mesh to */
var() array<name> TailBoneAttachNames;

/** face bone names -- list of bones that should be considered the 'face' that we will slow down for */
var() array<name> FaceBoneNames;

/** local index of the last bone in the chain we have hidden (used to replication hide negotiation) */
var transient int LocalLastUnHiddenTailIndex;

/** index into the tail bone array which represents the end of the tail right now  -- replicated*/
var repnotify transient int CurrentTailEndIndex;

/** current health of each tail segment */
var transient array<float> CurrentTailHealth;

/** how much damage is applied to the serapede when it gets hit in places that are not its last tail segment */
var() config float DamageMultiplierForNonTailHits;

/** how much damage each segment can take before blowing off */
var() config float StartingTailSegmentHealth;

/** when this is player controlled this modifier will be applied to the health of the serapede's tail segments */
var() config float PlayerHealthModifier;

/** when this is player controlled this modifier will be applied to melee damage dealt */
var() config float PlayerDamageModifier;

/** radius collision check to use when checking fo rplayer melee targets */
var() config float PlayerHitRadius;

/** offset from location to use for checking player melee targets */
var() config float PlayerHitOffset;

/** maximum groundspeed for the serapede when far away from an enemy */
var() config float MaxGroundSpeed;

/** groundspeed serapede should use when it has no enemy */
var() config float NoEnemyGroundSpeed;

/** Groundspeed for serapedes in Siege */
var() config float SiegeGroundSpeedMin, SiegeGroundSpeedMax;

/** the closer to his enemy the faster the serapede will go.  Groundspeed will interp from default up to maxgroundspeed
    within this window of distance from enemy */
var() config vector2d DistanceFromEnemyGroundSpeedWindow;

/** how long face shot speed reduction should last */
var() config float FaceShotSpeedReductionDuration;

var() config float FaceShotHitReactionTime;

var SkeletalMeshComponent GutsComp;
var StaticMeshComponent DamageableTailSegmentComponent;

/** whether we are reared up currently -- replicated */
var repnotify bool bRearUp;

/** cached reference to the rear up aim blend */
var transient AnimNodeBlend AimBlend;
var transient AnimNodeBlendList RearUpBlend;
/** cached reference to the tail skel control */
var transient GearSkelCtrl_Serapede TailSkelCtrl;

/** period (in world units) of the lateral sway as we move */
var() float MovementLateralSwayPeriod;
/** distance to move laterally during lateral sway */
var() float MovementLateralSwayLatOffset;

/** if less than this tail segments are still alive kill the 'pede */
var() int MinTailSegmentsAlive;

/** min amount of alive tail segments required to rear up */
var() int MinTailSegmentsForRearUp;

// used to save the location we were at when a movetoward latent action was begun
var transient BasedPosition MoveTowardStartPos;

// antenna aimoffset
var repnotify transient vector2D  AntennaAimOffsetPct;

var() config float LastSerapedeMelee;
var() config float MinTimeBetweenMelees;

/** SOUNDS */
var SoundCue Vocal_Ambient;
var SoundCue Vocal_Alerted;
var SoundCue Vocal_Angry;
var SoundCue Vocal_HeadRaise;
var SoundCue Vocal_HeadLower;
var SoundCue Vocal_Death;
var SoundCue Vocal_Pain;
var SoundCue Vocal_React;
var SoundCue Vocal_Hiss;
var SoundCue Vocal_ShockCue;

var SoundCue Attack_success;
var SoundCue HeadMove;
var SoundCue HeadUpLoop;
var SoundCue HeadRaise;
var SoundCue HeadLower;
var SoundCue FootStepCue;

var SoundCue TailSegmentPopCue;

var() vector2d FootStepPitchRange;
var()	  int	   NumFootStepComponents;
/** sound comps */
var transient AudioComponent HeadUpLoopComp;
var transient array<AudioComponent> MovementAudioComps;

var transient float LastChargeSoundPlayTime;

/** played when a tail segment is destroyed */
var ParticleSystem TailExplosionEffect;

/** 'electric' effect between legs */
var ParticleSystem LegLightningEffect;
var transient ParticleSystemComponent LegLightningPSysComp;


/** saved modifier for groundspeed of serapede */
var float GroundSpeedMod;

/** saved off last valid view rotation (that wasn't within tail cone) */
var vector LastValidViewDir;
/** max dot with tail axis to clamp against */
var config float MaxDotToTailAxis;

/** Offset to look when she rears up **/
var transient vector    OffsetToLook;
var transient FLOAT     OffsetLookTime;
/** How far should she look away from the target **/
var INT                 LookOffsetSize;

/** used for AI only.. last time we acquired a target */
var transient float LastTargetAcquisitionTime;

/** amount of time to apply speed boost for target acquisition */
/** Currently this variable isn't used - REMOVE if this continues **/
var config float TargetAcquireSpeedBoostTime;

/** amount of speed to boost when we've acquired a target recently */
/** Currently this variable isn't used - REMOVE if this continues **/
var config int TargetAcquiredSpeedBoost;

/** used for AI only.. last time tail got blown off*/
var transient float LastTailBlownOffTime;

/** amount of time to apply speed boost when tail got blown off*/
/** Currently this variable isn't used - REMOVE if this continues **/
var config float TailBlownOffSpeedBoostTime;

/** amount of speed to boost when tail has been blown off */
/** Currently this variable isn't used - REMOVE if this continues **/
var config float TailBlownOffSpeedBoostModifier;

var protected const MaterialInterface DamageableTailSegmentMaterial;

var() protected config float SiegeSteeringPct;

/** Death explosion template */
var instanced GearExplosion ExplosionTemplate;
/** Config damage values */
var config float DeathExplosionDamage;
var config float DeathExplosionDamageRadius;
var config float DeathExplosionDamageFalloff;

/** Shock Socket Name to attach **/
var repnotify transient name ShockSocketName;
var transient vector    ShockDir;
var class<GearDamageType> ShockDamageType;
var array<name> ShockSocketNames;
var ParticleSystem ShockEffect;

var transient GearSkelCtrl_SerapedeAntennaIK LeftAntenna, RightAntenna;
var transient SkelControlSingleBone    LeftAntennaRoot, RightAntennaRoot, Claws;

replication
{
	if (Role == ROLE_Authority)
		bRearUp, CurrentTailEndIndex, AntennaAimOffsetPct, LastTargetAcquisitionTime, LastTailBlownOffTime, ShockDir, ShockSocketName;
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == 'bRearUp')
	{
		SetRearUp(bRearUp,true);
	}
	else if(VarName == 'CurrentTailEndIndex')
	{
		UpdateTailPosition(CurrentTailEndIndex);
	}
	else if (VarName == 'ShockSocketName')
	{
		AttachShockEffect(ShockSocketName, ShockDir);
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

cpptext
{
	virtual UBOOL GetMoveDelta(FVector& out_Delta, const FVector& Dest);

	virtual FVector AdjustDestination(class AActor* GoalActor,FVector Dest=FVector(EC_EventParm));

	UBOOL IgnoreBlockingBy( const AActor *Other ) const;
};

/** returns the axis pointing backward from the head downt he tail */
native final function vector GetTailViewLimitAxis();

/** checks all bone rotation to see if it's safe to rear up or not **/
native final function bool CanRearUp();

/**
 * Called from PlayerController UpdateRotation() -> ProcessViewRotation() to (pre)process player ViewRotation
 * adds delta rot (player input), applies any limits and post-processing
 * returns the final ViewRotation set on PlayerController
 *
 * @param	DeltaTime, time since last frame
 * @param	ViewRotation, actual PlayerController view rotation
 * @input	out_DeltaRot, delta rotation to be applied on ViewRotation. Represents player's input.
 * @return	processed ViewRotation to be set on PlayerController.
 */
simulated function ProcessViewRotation( float DeltaTime, out rotator out_ViewRotation, out Rotator out_DeltaRot )
{
	local vector TailAxis;
	local vector ViewDirNoZ,ViewDIr;


	Super.ProcessViewRotation(DeltaTime, out_ViewRotation, out_DeltaRot);

	TailAxis = GetTailViewLimitAxis();

	TailAxis.Z = 0;
	TailAxis = Normal(TailAxis);

	ViewDir = vector(out_ViewRotation);
	ViewDirNoZ = ViewDir;
	ViewDirNoZ.Z = 0;
	ViewDirNoZ = Normal(ViewDir);

	if( LastValidViewDir != vect(0,0,0) && (TailAxis dot LastValidViewDir) < MaxDotToTailAxis )
	{
		if( (TailAxis dot ViewDirNoZ) > MaxDotToTailAxis )
		{
			out_ViewRotation = Rotator(LastValidViewDir);
			return;
		}
	}
	LastValidViewDir = ViewDir;
}

simulated function FaceRotation(rotator NewRotation, float DeltaTime)
{
	// Do not update Pawn's rotation depending on controller's ViewRotation if in FreeCam.
	// If human player, don't apply pitch.
	if (!InFreeCam() && IsHumanControlled())
	{
		NewRotation.Pitch = 0;
	}

	Super.FaceRotation(NewRotation, DeltaTime);
}

// called when movetoward starts, lets us save off the location we were at when our move started for
// lateral movement phase
event MoveTowardStarted()
{
	Vect2BP(MoveTowardStartPos,Location);
}

simulated function bool CanBeSpecialMeleeAttacked( GearPawn Attacker )
{
	return FALSE;
}

simulated function PostBeginPlay()
{
	local int i;
	local GearInventoryManager Inv;

	DamageableTailSegmentComponent.SetMaterial(0,DamageableTailSegmentMaterial);

	Super.PostBeginPlay();

	CurrentTailEndIndex = TailBoneNames.length - 1;
	LocalLastUnHiddenTailIndex = CurrentTailEndIndex;
	CurrentTailHealth.length = TailBoneNames.length;

	for (i = 0; i < CurrentTailHealth.length; i++)
	{
		CurrentTailHealth[i] = StartingTailSegmentHealth;
	}

	DefaultHealth = GetTotalMaxHealth();
	HealthMax = DefaultHealth;
	Health = GetTotalCurrentHealth();

	GutsComp.SetHidden(TRUE);

	AmbientSoundLoop();

	SetupAudioComponents();

	Mesh.AttachComponent(DamageableTailSegmentComponent,TailBoneNames[TailBoneNames.length-1]);
	DamageableTailSegmentComponent.SetHidden(false);
	DamageableTailSegmentComponent.SetShadowParent(Mesh);
	DamageableTailSegmentComponent.SetLightEnvironment(LightEnvironment);
	DamageableTailSegmentComponent.MotionBlurScale=0;

	//
	LegLightningPSysComp = new(self) class'ParticleSystemComponent';
	AttachComponent(LegLightningPSysComp);
	LegLightningPSysComp.SetActorParameter('BoneSocketActor', self);
	LegLightningPSysComp.SetTemplate(LegLightningEffect);
	LegLightningPSysComp.SetTickGroup(TG_EffectsUpdateWork);
	LegLightningPSysComp.SetAbsolute(false, true, false);

	// we don't need accuracy updates every frame, thanks
	Inv = GearInventoryManager(InvManager);
	if( Inv != none )
	{
		Inv.bSkipAccuracyUpdates = true;
	}

	if (Role == ROLE_Authority)
	{
		SetTimer(0.5, true, nameof(WarnAI));
	}
}

function PossessedBy(Controller C, bool bVehicleTransition)
{
	local int i;

	Super.PossessedBy(C, bVehicleTransition);
	if (GearPC(C) != None)
	{
		WalkingPhysics = PHYS_Walking;
		SetPhysics(PHYS_Falling);

		// modify tail health!
		for (i = 0; i < CurrentTailHealth.length; i++)
		{
			CurrentTailHealth[i] *= PlayerHealthModifier;
		}

	}
}

simulated function SetupAudioComponents()
{
	local int i;

	HeadUpLoopComp = new(self) class'AudioComponent';
	HeadUpLoopComp.SoundCue = HeadUpLoop;
	AttachComponent(HeadUpLoopComp);
	HeadUpLoopComp.FadeOut(0.f,0.f);
	HeadUpLoopComp.bUseOwnerLocation=true;
	HeadUpLoopComp.bShouldRemainActiveIfDropped=true;

	for(i=0;i<NumFootStepComponents;++i)
	{
		//MovementAudioComps.AddItem(CreateAudioComponent(FootStepCue,TRUE,TRUE));
		MovementAudioComps.AddItem(new(self) class'AudioComponent');
		MovementAudioComps[i].SoundCue = FootStepCue;
		Mesh.AttachComponent(MovementAudioComps[i],TailBoneAttachNames[i*(TailBoneAttachNames.length/NumFootStepComponents)]);
		MovementAudioComps[i].FadeOut(0.f,0.f);
		MovementAudioComps[i].bUseOwnerLocation=true;
		MovementAudioComps[i].bShouldRemainActiveIfDropped=true;
	}


}

simulated function CleanupOnDeath()
{
	local int i;
	for(i=0;i<NumFootStepComponents;++i)
	{
		MovementAudioComps[i].FadeOut(0.f,0.f);
	}
	MovementAudioComps.length=0;

	HeadUpLoopComp.FadeOut(0,0);
	HeadUpLoopComp=none;

	DamageableTailSegmentComponent.SetHidden(true);

	ClearTimer(nameof(AmbientSoundLoop));
}

simulated event Destroyed()
{
	Super.Destroyed();

	ClearTimer(nameof(AmbientSoundLoop));
}

function SetMovementPhysics()
{
	SetPhysics(WalkingPhysics);
}

/** Animation stopped playing notify */
simulated event OnAnimEnd(AnimNodeSequence SeqNode, float PlayedTime, float ExcessTime)
{
	// rear down
	if (RearUpBlend.NodeTotalWeight > 0.f)
	{
		if (RearUpBlend.ActiveChildIndex == 0)
		{
			RearUpDone();
			return;
		}
		else if (RearUpBlend.ActiveChildIndex == 2)
		{
			RearDownDone();
			return;
		}
	}

	Super.OnAnimEnd(SeqNode, PlayedTime, ExcessTime);
}

/** notifies AI that are at risk of being melee'd */
final function WarnAI()
{
	local GearAI AI;
	local float Loudness, Dist, MeleeAttackRange;
	local int i;
	local vector BoneLoc;

	if (!IsZero(Velocity))
	{
		// we don't have "real" footsteps but rather a constant sound so just notify AI periodically
		if (Role == ROLE_Authority)
		{
			// Noise loudness based on movement speed
			if ( GroundSpeed  > 0 )
			{
				Loudness = (VSize(Velocity) / GroundSpeed);
				MakeNoise(Loudness * Loudness * Loudness, 'NOISETYPE_FootStep');
			}
		}

		MeleeAttackRange = GetAIMeleeAttackRange();
		foreach WorldInfo.AllControllers(class'GearAI', AI)
		{
			if (AI.Pawn != None)
			{
				// check if we are in melee range
				Dist = VSize(AI.Pawn.Location - Location);
				if ( AI.Pawn != None &&
					(Dist < MeleeAttackRange || (Dist < GroundSpeed && Normal(Velocity) dot Normal(AI.Pawn.Location - Location) > 0.7)) &&
					FastTrace(AI.Pawn.Location, Location) )
				{
					AI.ReceiveChargeTargetWarning(self);
				}

				// also do an additional visibility check, since standard check is based on head location
				// for efficiency, check last location AI saw us and if any part of us is still there, assume we're still visible
				i = AI.LocalEnemyList.Find('Pawn', self);
				if (i != INDEX_NONE && !AI.LocalEnemyList[i].bSeenLastFrame && AI.LocalEnemyList[i].LastVisibleTime > 0.0)
				{
					Mesh.FindClosestBone(AI.LocalEnemyList[i].AsyncVisibleLocation, BoneLoc);
					if (VSize(AI.LocalEnemyList[i].AsyncVisibleLocation - BoneLoc) < 64.0)
					{
						if (Controller != None && Controller.bIsPlayer)
						{
							AI.SeePlayer(self);
						}
						else
						{
							AI.SeeMonster(self);
						}
					}
				}
			}
		}
	}
}

reliable server function ServerSetRearUp(bool bUp)
{
	SetRearUp(bUp);
}

simulated function SetRearUp(bool bUp, optional bool bForce)
{
	if(CurrentTailEndIndex < MinTailSegmentsForRearUp)
	{
		bUp = false;
	}

	// if same call gets called multiple times, don't do it
	if (bRearUp==bUp&&!bForce)
	{
		return;
	}

	if (bUp && !CanRearUp())
	{
		// FIXME: should I pass if bForce??? 
		return;
	}

	if (LatentActions.Length > 0)
	{
		// if it's in latent action - i.e matinee or moving, don't do rear up
		return;
	}

	if( Role < Role_Authority )
	{
		ServerSetRearUp(bUp);
	}

	bLockRotation=bUp;
	bRearUp=bUp;

	if (Role == Role_Authority)
	{
		// whenever rear up or down, clear it up
		ClearLookPosition();
	}

	if(bUp)
	{
		// if you turn off right here
		// you can see animation goes back to original pose and rear up
		// Since it doesn't have blending
		// Deley to turn it off
		ClearTimer('TurnOffTailController');
		SetTimer(0.2f, FALSE, 'TurnOffTailController');

		AimBlend.SetBlendTarget(1.0,0.2f);
		RearUpBlend.SetActiveChild(0, 0.25f);
		PlaySound(HeadRaise,true,,true);

		// play vocal sometimes
		if(Rand(1) > 0.6)
		{
			PlaySound(Vocal_HeadRaise,true,,true);
		}
	}
	else
	{
		RearUpBlend.SetActiveChild(2, 0.25f);
		PlaySound(HeadLower,true,,true);
		// play vocal sometimes
		if(Rand(1) > 0.6)
		{
			PlaySound(Vocal_HeadLower,true,,true);
		}

		// Same thing with turning it off
		// When turn on, delay it
		ClearTimer('TurnOnTailController');
		SetTimer(0.2f, FALSE, 'TurnOnTailController');
	}
}

// Allow tail controller to adjust all bones
simulated function TurnOnTailController()
{
	ClearTimer('TurnOnTailController');
	TailSkelCtrl.bOnlyAdjustSomeBones=FALSE;
}

// Disallow tail controller to adjust some bones
simulated function TurnOffTailController()
{
	ClearTimer('TurnOffTailController');
	TailSkelCtrl.bOnlyAdjustSomeBones=TRUE;
}

// called when rear up is done
simulated function RearUpDone()
{
	RearUpBlend.SetActiveChild(1, 0.25f);
	HeadUpLoopComp.FadeIn(0.5,1.0);
}

// called when rear down is done
simulated function RearDownDone()
{
	HeadUpLoopComp.FadeOut(0.5,1.0);
	AimBlend.SetBlendTarget(0.0 ,0.2f);
	TailSkelCtrl.bOnlyAdjustSomeBones=FALSE;
}

/** Cache additional animation nodes. */
simulated function CacheAnimNodes()
{
	Super.CacheAnimNodes();

	AimBlend = AnimNodeBlend(Mesh.FindAnimNode('aimblend'));
	AimBlend.SetBlendTarget(0.0,0.0);

	// rear up blend is handling rearing up/down/idle
	RearUpBlend = AnimNodeBlendList(Mesh.FindAnimNode('RearUpBlend'));
	// 1 is idle
	RearUpBlend.SetActiveChild(1,0.25f);

	TailSkelCtrl = GearSkelCtrl_Serapede(Mesh.FindSkelControl('tail_control'));
	TailSkelCtrl.SetSkelControlStrength(1.f, 0.25f);

	LeftAntenna = GearSkelCtrl_SerapedeAntennaIK(Mesh.FindSkelControl('LeftAntenna'));
	LeftAntenna.SetSkelControlActive(TRUE);

	RightAntenna = GearSkelCtrl_SerapedeAntennaIK(Mesh.FindSkelControl('RightAntenna'));
	RightAntenna.SetSkelControlActive(TRUE);

	LeftAntennaRoot = SkelControlSingleBone(Mesh.FindSkelControl('LeftAntennaRoot'));
	LeftAntennaRoot.SetSkelControlActive(FALSE);

	RightAntennaRoot = SkelControlSingleBone(Mesh.FindSkelControl('RightAntennaRoot'));
	RightAntennaRoot.SetSkelControlActive(FALSE);

	Claws = SkelControlSingleBone(Mesh.FindSkelControl('Claws'));
	Claws.SetSkelControlActive(FALSE);
}

simulated function ClearAnimNodes()
{
	Super.ClearAnimNodes();

	AimBlend=none;
	RearUpBlend=none;
}

simulated function bool IsEndOfTail(name BoneName)
{
	return (TailBoneNames[CurrentTailEndIndex] == BoneName);
}

simulated function bool IsFaceShot(TraceHitInfo HitInfo)
{
	return FaceBoneNames.Find(HitInfo.BoneName) != INDEX_NONE;
}

simulated function vector LastBlownOffTailLocation()
{
	return Mesh.GetBoneLocation(TailBoneNames[LocalLastUnHiddenTailIndex]);
}

simulated function PlayTailSegmentBlownOff()
{
	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		PlaySound(Vocal_Pain, true,, true);
		PlaySound(TailSegmentPopCue, true,, true);
		WorldInfo.MyEmitterPool.SpawnEmitter(TailExplosionEffect, Mesh.GetBoneLocation(TailBoneNames[LocalLastUnHiddenTailIndex]), rotator(Mesh.GetBoneAxis(TailBoneNames[LocalLastUnHiddenTailIndex], AXIS_X)));
		GearPawnFX.SpawnSerapedeSplat();
	}
}

simulated function PlayDeath(class<GearDamageType> GearDamageType, vector HitLoc)
{
	CleanupOnDeath();
	Super.PlayDeath(GearDamageType,HitLoc);
}

/** Ground Speed should be replicated by server **/
function UpdateGroundSpeed()
{
	local float DistToEnemy;
	local float Alpha;

	if (GearPC(Controller) != None)
	{
		if( bRearUp )
		{
			GroundSpeed = 0;
		}
		else
		{
			GroundSpeed = Lerp(SiegeGroundSpeedMin, SiegeGroundSpeedMax, 1.0 - (float(CurrentTailEndIndex) / float(TailBoneNames.length)));
		}
	}
	else
	{
		if (CurrentTailEndIndex == TailBoneNames.length - 1)
		{
			if (Controller != None && Controller.Enemy != None)
			{
				DistToEnemy = VSize(Controller.Enemy.Location - Location);
				Alpha = FClamp((DistToEnemy - DistanceFromEnemyGroundSpeedWindow.X) / (DistanceFromEnemyGroundSpeedWindow.Y - DistanceFromEnemyGroundSpeedWindow.X), 0.0, 1.0);
				GroundSpeed = Lerp(DefaultGroundSpeed, MaxGroundSpeed, Alpha);
			}
			else
			{
				GroundSpeed = NoEnemyGroundSpeed;
			}
		}
		else
		{
			GroundSpeed = Lerp(DefaultGroundSpeed, MaxGroundSpeed, 1.0 - (float(CurrentTailEndIndex) / float(TailBoneNames.length)));
		}

		// By Lee P's request, we remove all modifiers and start from clean
		// only thing applies now is speed modifier for # of segments
		// if we acquired a target recently, apply speed boost!
// 		if (`TimeSince(LastTargetAcquisitionTime) < TargetAcquireSpeedBoostTime)
// 		{
// 			GroundSpeed += TargetAcquiredSpeedBoost;
// 
// 			// cap at max
// 			GroundSpeed = Min(GroundSpeed,MaxGroundSpeed);
// 		}
// 
// 		if ( `TimeSince(LastTailBlownOffTime) < TailBlownOffSpeedBoostTime )
// 		{
// 			GroundSpeed*=TailBlownOffSpeedBoostModifier;
// 		}
		// FIXMELINA: Fix this back
		// around obstacle mesh, slow it down
//		if ( TailSkelCtrl.AroundObstacleMesh )
//		{
//			GroundSpeed *= 0.5f;
//		}
	}

	// we still need this. This can be set by fortification.
	GroundSpeed *= GroundSpeedMod;


}
simulated function int UpdateTailPosition(int NewPos)
{
	local int NumBlownOff;
	local int i;

	NumBlownOff = LocalLastUnHiddenTailIndex-NewPos;

	if(NumBlownOff == 0)
	{
		return 0;
	}

	for(i=LocalLastUnHiddenTailIndex;i>NewPos;--i)
	{
		Mesh.HideBoneByName(TailBoneNames[i],PBO_Term);
	}

	if(NumBlownOff>1)
	{
		// dur -- split tail
	}
	else
	{
		PlayTailSegmentBlownOff();
	}


	CurrentTailEndIndex = NewPos;

	UpdateGroundSpeed();

	if(CurrentTailEndIndex >= 0)
	{
		if(LocalLastUnHiddenTailIndex == TailBoneNames.length-1)
		{
			Mesh.AttachComponent(GutsComp,TailBoneAttachNames[CurrentTailEndIndex]);
			GutsComp.SetHidden(false);
			GutsComp.SetShadowParent(Mesh);
			GutsComp.SetLightEnvironment(LightEnvironment);
			GutsComp.MotionBlurScale=0;
			GutsComp.WakeRigidBody();
		}
		else
		{
			Mesh.DetachComponent(GutsComp);
			Mesh.AttachComponent(GutsComp,TailBoneAttachNames[CurrentTailEndIndex]);
		}

		// move the aim attractor to the next segment
		AimAttractors[0].BoneName = TailBoneAttachNames[CurrentTailEndIndex];

		Mesh.DetachComponent(DamageableTailSegmentComponent);
		Mesh.AttachComponent(DamageableTailSegmentComponent,TailBoneNames[CurrentTailEndIndex]);

	}

	LocalLastUnHiddenTailIndex = NewPos;

	if(CurrentTailEndIndex < MinTailSegmentsForRearUp)
	{
		SetRearUp(false);
	}

	return NumBlownOff;

}

function ScaleDefaultHealth(float Multiplier, bool bResetCurrentHealth)
{
	local int i;

	StartingTailSegmentHealth *= Multiplier;
	for (i = 0; i < CurrentTailHealth.length; i++)
	{
		if (CurrentTailHealth[i] > 0)
		{
			if (bResetCurrentHealth)
			{
				CurrentTailHealth[i] = StartingTailSegmentHealth;
			}
			else
			{
				CurrentTailHealth[i] = Min(CurrentTailHealth[i], StartingTailSegmentHealth);
			}
		}
	}

	DefaultHealth = GetTotalMaxHealth();
	HealthMax = DefaultHealth;
	Health = GetTotalCurrentHealth();
}

final function float GetTotalMaxHealth()
{
	return StartingTailSegmentHealth * (TailBoneNames.length - MinTailSegmentsAlive);
}

final function float GetTotalCurrentHealth()
{
	local int i;
	local float TotalHealth;

	for (i = MinTailSegmentsAlive; i < CurrentTailHealth.length; i++)
	{
		TotalHealth += CurrentTailHealth[i];
	}

	return TotalHealth;
}

function TailSegmentBlownOff(int Idx, Pawn InstigatedBy, class<GearDamageType> GearDamageType, vector InMomentum)
{
	UpdateTailPosition(Idx-1);

	if( MyGearAI != none )
	{
		GearAI_Serapede(MyGearAI).TailSegmentBlownOff(InstigatedBy);
	}

	if(CurrentTailEndIndex < MinTailSegmentsAlive)
	{
		TailDestroyed_DoDeath(InstigatedBy.Controller,GearDamageType,Location,InMomentum);
	}
}

// return TRUE if damage was tail damage
function TakeTailDamage(name boneName, int Damage, Pawn InstigatedBy, class<GearDamageType> GearDamageType, vector InMomentum)
{
	local int Idx, NextSegmentDamage;
	local GearPRI InstigatorPRI, PRI;
	local GearGRI GRI;

	Idx = TailBoneNames.Find(boneName);

	if (Idx != INDEX_NONE)
	{
		// radius damage can hit multiple tail segments if it does enough damage
		if ((bTakingRadiusDamage || GearDamageType == class'GDT_InstagibMelee') && Damage > CurrentTailHealth[Idx])
		{
			NextSegmentDamage = Damage - CurrentTailHealth[Idx];
			Damage = CurrentTailHealth[Idx];
		}

		CurrentTailHealth[Idx] -= Damage;
		if (CurrentTailHealth[Idx] <= 0)
		{
			CurrentTailHealth[Idx] = 0;
			TailSegmentBlownOff(Idx, InstigatedBy, GearDamageType, InMomentum);
		}

		GRI = GearGRI(WorldInfo.GRI);
		PRI = GearPRI(PlayerReplicationInfo);
		InstigatorPRI = GearPRI(InstigatedBy.PlayerReplicationInfo);
		// Log the hit, but only if the round is in progress
		if (GRI.GameStatus == GS_RoundInProgress && PRI != None)
		{
			PRI.ScoreHit(InstigatorPRI, GetTotalMaxHealth(), GetTotalCurrentHealth(), Damage, GearDamageType, InstigatedBy);
		}

		if (NextSegmentDamage > 0 && Idx > 0 && Health > 0)
		{
			// continue to next segment
			TakeTailDamage(TailBoneNames[Idx - 1], NextSegmentDamage, InstigatedBy, GearDamageType, InMomentum);
		}
		else
		{
			// update total value for HUD, AI, etc
			Health = GetTotalCurrentHealth();
		}
	}
}

function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	ClearTimer(nameof(AmbientSoundLoop));
	return Super.Died(Killer,DamageType,HitLocation);
}

function TailDestroyed_DoDeath(Controller InKillerController, class<GearDamageType> InDamageType, Vector InHitLocation, Vector InMomentum)
{
	local GearPRI KillerPRI,MyPRI;

	`LogSM("");

	TearOffMomentum = InMomentum;
	Health			= -1;

	// grab the last person we know of who hurt us
	if( InKillerController != None )
	{
		KillerPRI = GearPRI(InKillerController.PlayerReplicationInfo);
		MyPRI = GearPRI(PlayerReplicationInfo);
		if( KillerPRI != None && MyPRI != none )
		{
			KillerPRI.ScoreInstantKill(MyPRI, InDamageType, GDT_NORMAL);
		}
	}
	else if (ClassIsChildOf(InDamageType, class'GDT_Environment'))
	{
		GearPRI(PlayerReplicationInfo).ScoreDeath(None, InDamageType, GDT_Normal, InDamageType.default.bSuicidePenalty ? -100 : 0);
	}
	else
	{
		GearPRI(PlayerReplicationInfo).ScoreDeath(None, InDamageType, GDT_Normal);
	}

	PlaySound(Vocal_Death);
	// perform the appropriate death
	Died(InKillerController, InDamageType, InHitLocation);
}


/** Handle taking damage in various body locations */
function AdjustPawnDamage( out int Damage, Pawn InstigatedBy, vector HitLocation, out vector Momentum,
				class<GearDamageType> GearDamageType, Actor DamageCauser, optional out TraceHitInfo HitInfo )
{
	local float Orig_Damage;
	local int DmgF;

	// melee will miss anything but the tail, but the melee code doesn't set the hit bone correctly
	if (ClassIsChildOf(GearDamageType, class'GDT_Melee'))
	{
		HitInfo.BoneName = TailBoneNames[CurrentTailEndIndex];
	}
	// special case fortification wall damage to go direct to end segment (at a reduced rate) for user clarity and balance
	else if (GearFortification_Wall(DamageCauser) != None)
	{
		HitInfo.BoneName = TailBoneNames[CurrentTailEndIndex];
		Damage *= DamageMultiplierForNonTailHits;
	}

	DmgF = Damage;
	Orig_Damage = Damage;
	bAllowStoppingPower = false;
	if (!IsEndOfTail(HitInfo.BoneName) && HitInfo.HitComponent == Mesh)
	{
		DmgF *= DamageMultiplierForNonTailHits;
		Damage = Round(DmgF);
	}

	if (IsFaceShot(HitInfo))
	{
		bAllowStoppingPower = true;
		if (MyGearAI != None)
		{
			MyGearAI.ReactionManager.IncomingDamage(InstigatedBy, true, GearDamageType, HitInfo, MyGearAI.GetEnemyLocation(InstigatedBy), Orig_Damage);
		}
	}
	else
	{
		if (HitInfo.HitComponent != Mesh)
		{
			HitInfo.BoneName = TailBoneNames[CurrentTailEndIndex];
		}
		TakeTailDamage(HitInfo.BoneName, Damage, InstigatedBy, GearDamageType, Momentum);
	}
	Damage = 0;
}

simulated function bool ShouldPlayNonDamageHitEffects(const out ImpactInfo Impact, Pawn InstigatedBy, class<DamageType> InDamageType)
{
	return (InstigatedBy == self || !WorldInfo.GRI.OnSameTeam(InstigatedBy, self));
}

simulated function StartMeleeAttack()
{
	if (IsHumanControlled() && IsLocallyControlled())
	{
		if (WorldInfo.TimeSeconds - LastSerapedeMelee > MinTimeBetweenMelees && !bRearUp && CanDoSpecialMove(SM_Serapede_Attack) && !IsTimerActive(nameof(TurnOnTailController)))
		{
			LastSerapedeMelee = WorldInfo.TimeSeconds;
			GearPC(Controller).DoSpecialMove(SM_Serapede_Attack);
		}
	}
	else
	{
		Super.StartMeleeAttack();
	}
}

function bool DoMeleeDamageToTarget(GearWeap_Melee Wpn, Actor Target)
{
	local float Tolerance;
	local float Radius,Height, DotP;
	local actor HitActor;
	local vector Start, End;
	local ImpactInfo FirstHitInfo;
	local GearPawn EnemyGP;

		if (Target != None)
		{
		Tolerance = GetAIMeleeAttackRange() + PlayerHitRadius;
			Target.GetBoundingCylinder(Radius, Height);
			Tolerance += Radius;

			Start = Location;
			Start.Z -= 10.0; // need to be a bit lower so we can hit DBNO enemies
			End = Start + Normal(Target.Location - Location) * Tolerance;
			Start += Normal(End - Start) * GetCollisionRadius();

				HitActor = Target;
				FirstHitInfo.HitLocation = Target.Location;

			EnemyGP = GearPawn(Target);
			if( EnemyGP != None && EnemyGP.IsAKidnapper() && (HitActor == EnemyGP || HitActor == EnemyGP.InteractionPawn) )
			{
				DotP = Normal(Location-EnemyGP.Location) DOT Vector(EnemyGP.Rotation);
				if( DotP < 0 )
				{
					HitActor = EnemyGP;
				}
				else
				{
					HitActor = EnemyGP.InteractionPawn;
				}
			}


			if (HitActor == None)
			{
				// if we're starting the trace inside the enemy.. just call it good
				if (VSize(Start - Target.Location) < Radius && Abs(Start.Z - Target.Location.Z) < Height)
				{
					HitActor = Target;
				}
			}

			if ( HitActor == Target ||
				(EnemyGP != None && EnemyGP.IsAKidnapper() && HitActor == EnemyGP.InteractionPawn) )
			{

				Wpn.DoMeleeDamage(HitActor, FirstHitInfo.HitLocation, (MyGearAI != none) ? 1.0 : PlayerDamageModifier);
			return true;
			}
			}

	return false;
		}

function ANIMNOTIFY_DoMeleeDamage()
{
	local GearWeap_Melee Wpn;
	local Actor Target;
	local bool bSuccessfulyDidDamage;
	local AICmd_Attack_Serapede_Melee MeleeCmd;

	Wpn = GearWeap_Melee(Weapon);

	if (Wpn != None)
	{
		if (MyGearAI != None)
		{
			MeleeCmd = AICmd_Attack_Serapede_Melee(MyGearAI.GetActiveCommand());
		}
		foreach CollidingActors(class'Actor', Target, PlayerHitRadius, Location + vector(Rotation) * PlayerHitOffset, true)
		{
			if ( Target.bWorldGeometry ||
				GearDestructibleObject(Target) != None ||
				Target == self ||
				InteractiveFoliageActor(Target) != None ||
				(MyGearAI != none && Target != MyGearAI.Enemy && Target != MyGearAI.FireTarget && (MeleeCmd == None || Target != MeleeCmd.MeleeTarget)))
			{
					continue;
			}

			bSuccessfulyDidDamage = DoMeleeDamageToTarget(Wpn, Target) || bSuccessfulyDidDamage;
		}
	}

	PlayAttackSound(bSuccessfulyDidDamage);
}

// sound stubs
function PlayNewTargetAcquired()
{
	PlaySound(Vocal_Alerted);
}

function PlayChargingEnemy()
{
	if(`TimeSince(LastChargeSoundPlayTime) > 5.0)
	{
		PlaySound(Vocal_Hiss);
		LastChargeSoundPlayTime = WorldInfo.TimeSeconds;
	}
}

function PlayAttackSound(bool bSuccessful)
{
	if(bSuccessful)
	{
		PlaySound(Vocal_ShockCue);
	}
	else
	{
		PlaySound(Vocal_Hiss);
	}
}

function PlayHeadMoveSound()
{
	PlaySound(HeadMove);
}

function PlayAngrySound()
{
	PlaySound(Vocal_Angry);
}

function PlayShockSound()
{
	PlaySound(Vocal_ShockCue);
}

simulated function AmbientSoundLoop()
{
	PlaySound(Vocal_Ambient,TRUE,,true);
	SetTimer(randrange(8,12),false,nameof(AmbientSoundLoop));
}

simulated function UpdateFootStepAudio()
{
	local float PctMaxSpeed;
	local float PitchAdd;
	local float Speed;
	local int Idx;

	Speed = VSize(Velocity);
	if (Speed > 16)
	{
		PctMaxSpeed = Speed / MaxGroundSpeed;
		PitchAdd = Lerp(FootStepPitchRange.X, FootStepPitchRange.Y, PctMaxSpeed);
	}

	for (Idx = 0; Idx < MovementAudioComps.length; Idx++)
	{
		if (MovementAudioComps[Idx] != None)
		{
			MovementAudioComps[Idx].PitchMultiplier = 1.f + PitchAdd;

			if (!MovementAudioComps[Idx].IsPlaying() && Speed > 16)
			{
				MovementAudioComps[Idx].FadeIn(0.5,1);
			}
			else if (MovementAudioComps[Idx].IsPlaying() && Speed < 16)
			{
				MovementAudioComps[Idx].FadeOut(0.24,0);
			}
		}
	}

}

function SetGroundSpeedModifier(float NewModifier)
{
	GroundSpeedMod = NewModifier;
	UpdateGroundSpeed();
}

/** prevents serapede from moving all the way backward inside itself */
simulated function UpdateBackPedalDir()
{

	local GearPC MyGearPC;
	local vector RotDir;
	MyGearPC = GearPC(Controller);

	if( MyGearPC != none )
	{
		RotDir = -Vector(Rotation);
		if( (Acceleration dot RotDir) > 0.0 )
		{
			Acceleration = AccelRate * GetTailViewLimitAxis();
		}
	}
}

/** Clear Look Position
 * Whenever she rears up or down
 * Clear up used variables **/
function ClearLookPosition()
{
	if ( MyGearAI != none )
	{
		OffsetLookTime = 0.f;
		GearAI_Serapede(MyGearAI).ClearUpLookEnemy();
	}
}

/** Get Look Position
 * This is only for rear-up position
 * This dictates where antenna and head aimoffset goes
 * Creates more dynamic movement of head
 * This function only should be used by server
 */
function vector GetLookPosition(float DeltaTime)
{
	local vector LookPosition;
	local GearAI_Serapede SerapedeAI;

	if ( MyGearAI!=none )
	{
		SerapedeAI = GearAI_Serapede(MyGearAI);

		// If time expires, look for new offset
		if ( OffsetLookTime > 1.f + FRand() * 2.f )
		{
			// pick other position
			OffsetLookTime = 0.f;
			OffsetToLook.X  = Rand(LookOffsetSize*2)-LookOffsetSize;
			OffsetToLook.Y  = Rand(LookOffsetSize*2)-LookOffsetSize;
			OffsetToLook.Z  = 0.f;
		}
		// if hasn't been set yet, set new offset
		else if ( OffsetLookTime == 0.f )
		{
			// pick other position
			OffsetToLook.X  = Rand(LookOffsetSize*2)-LookOffsetSize;
			OffsetToLook.Y  = Rand(LookOffsetSize*2)-LookOffsetSize;
			OffsetToLook.Z  = 0.f;
		}

		// apply Offset
		LookPosition = SerapedeAI.GetLookPosition() + OffsetToLook;
		// Accumulate Delta Time
		OffsetLookTime += DeltaTime;
	}

	return LookPosition;
}

simulated function bool CanEngageMelee()
{
	return (!bRearUp && Super.CanEngageMelee());
}

simulated function Tick(float DeltaTime)
{
	local vector StartLoc, EndLoc, CamLoc;
	local rotator CamRot, CenterRot;
	local GearPC GPC;
	local matrix BoneMatrix;

	Super.Tick(DeltaTime);

	UpdateFootStepAudio();

	UpdateGroundSpeed();

	UpdateBackPedalDir();

	if (MyGearAI == None && IsLocallyControlled() && !IsDoingASpecialMove())
	{
		GPC = GearPC(COntroller);
		if (GPC != None)
		{
			SetRearUp(GPC.IsButtonActive(GB_LeftTrigger) || GPC.IsButtonActive(GB_LeftBumper));
		}
	}

	// allow Fire to also trigger melee
	if (IsLocallyControlled() && IsHumanControlled() && bool(Controller.bFire))
	{
		StartMeleeAttack();
		Controller.bFire = 0;
	}

	// if server, set up look position
	if ( Controller != none )
	{
		//WorldInfo.FlushPersistentDebugLines();
		BoneMatrix = Mesh.GetBoneMatrix(Mesh.MatchRefBone('Segment_headoffset'));
		StartLoc = MatrixGetOrigin(BoneMatrix);

		if ( MyGearAI != none )
		{
			if (bRearUp)
			{
				EndLoc = GetLookPosition( DeltaTime );
			}
			else if ( MyGearAI.Enemy!=none )
			{
				EndLoc = MyGearAI.Enemy.Location;
			}
			else
			{
				EndLoc = MyGearAI.LastSquadLeaderPosition;
			}
		}
		else if ( IsHumanControlled() )
		{
			GearPC(Controller).GetPlayerViewPoint(CamLoc, CamRot);
			EndLoc = CamLoc + vector(CamRot)*300;
		}

		// Use Segment05's rotation as base rotation
		// since that bone doesn't move away from root much
		CenterRot = MatrixGetRotator(Mesh.GetBoneMatrix(Mesh.MatchRefBone('Segment05')));
		// Since Serapede bone is Y axis aligned. Rotate +90 to have X aligned
		CenterRot.Yaw += 16384;
		//WorldInfo.DrawDebugLine(StartLoc, EndLoc, 255, 0, 0, TRUE);
		//WorldInfo.DrawDebugLine(StartLoc, StartLoc+vector(CenterRot), 0, 255, 0, TRUE);
		if( MyGearAI != none )
		{
			// for AI slow down a bit - looks better that way.
			CalculateAimOffset(CenterRot, rotator(EndLoc-StartLoc), MakeRotator(16384.f, 16384.f, 0), 0.8f, DeltaTime, AntennaAimOffsetPct );
		}
		else
		{
			CalculateAimOffset(CenterRot, rotator(EndLoc-StartLoc), MakeRotator(16384.f, 16384.f, 0), float(RotationRate.Yaw) / 16384.0, DeltaTime, AntennaAimOffsetPct );
		}
	}
	else
	{
		// Clear
		AntennaAimOffsetPct.X = AimInterpTo(AntennaAimOffsetPct.X, 0.f, DeltaTime, 0.5f);
		AntennaAimOffsetPct.Y = AimInterpTo(AntennaAimOffsetPct.Y, 0.f, DeltaTime, 0.5f);
	}

	if (LeftAntenna.bHaveHit)
	{
		if ( LeftAntennaRoot.StrengthTarget == 0.f )
		{
			LeftAntennaRoot.SetSkelControlActive(TRUE);
		}
	}
	else
	{
		if ( LeftAntennaRoot.StrengthTarget == 1.f )
		{
			LeftAntennaRoot.SetSkelControlActive(FALSE);
		}
	}

	if (RightAntenna.bHaveHit)
	{
		if ( RightAntennaRoot.StrengthTarget == 0.f )
		{
			RightAntennaRoot.SetSkelControlActive(TRUE);
		}
	}
	else
	{
		if ( RightAntennaRoot.StrengthTarget == 1.f )
		{
			RightAntennaRoot.SetSkelControlActive(FALSE);
		}
	}

	if (LeftAntenna.bHaveHit || RightAntenna.bHaveHit)
	{
		if (Claws.StrengthTarget == 0.f)
		{
			Claws.SetSkelControlActive(TRUE);
		}
	}
	else
	{
		if (Claws.StrengthTarget == 1.f)
		{
			Claws.SetSkelControlActive(FALSE);
		}
	}
}

function bool DoMantle(GearAI AI, INT Dir, vector MoveStart, vector MoveDest, CoverInfo Info)
{
	return class'AICmd_Serapede_Move_Mantle'.static.MantleEdge( MyGearAI, MoveStart, MoveDest, Info );
}

function bool HasArrivedAtMantleStart(Vector MoveStart)
{
	local float ArrivalDist;
	ArrivalDist = 2.0f * CylinderComponent.CollisionRadius;
	return ( VSizeSq2D(MoveStart-Location) < ArrivalDist*ArrivalDist );
}

/**
 * The serapede should only look for melee in the tail
 *
 * @return the location of the tail
 */
simulated function vector GetMeleeHitTestLocation()
{
	return Mesh.GetBoneLocation(TailBoneNames[CurrentTailEndIndex]) + vect(0,0,40);
}

function bool OverrideAimLocation(out vector AimLoc, vector StartLoc, GearAI ShooterAI)
{
	// override to point at tail
	AimLoc = Mesh.GetBoneLocation(TailBoneNames[CurrentTailEndIndex]);
	return FastTrace(AimLoc, StartLoc,, true);
}

/** Custom Aimoffset for headworm
*  @param AimOffset: 2D vector of AimOffset
*  @return : TRUE if successfully found. FALSE otherwise
*/
event simulated bool GetCustomAimOffset( out vector2D  AimOffset )
{
	// if head is mutate, set it
	AimOffset = AntennaAimOffsetPct;

//	`log("AntennaAimOffsetPct "@AntennaAimOffsetPct.X@", "@AntennaAimOffsetPct.Y);

	return TRUE;
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	local MaterialInstanceTimeVarying MITV;
	local InterpCurveFloat GutsGlowCurve;

	Super.PlayDying(DamageType, HitLoc);

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		MITV = GutsComp.CreateAndSetMaterialInstanceTimeVarying(0);
		GutsGlowCurve.Points.length = 2;
		GutsGlowCurve.Points[0].OutVal = 1.0;
		GutsGlowCurve.Points[1].InVal = 1.5;
		MITV.SetScalarCurveParameterValue('Glow', GutsGlowCurve);
		MITV.SetScalarStartTime('Glow', 0.0);
	}

	PlayDeathExplosion();
}

simulated function PlayDeathExplosion()
{
	local vector SpawnLocation;
	local rotator SpawnRotation;
	local GearExplosionActor ExplosionActor;
	local GearProj_Grenade AttachedGrenade;
	local int AttachIdx;

	// Detonate attached grenades
	for( AttachIdx = 0; AttachIdx < Attached.length; ++AttachIdx )
	{
		AttachedGrenade = GearProj_Grenade(Attached[AttachIdx]);
		if( AttachedGrenade != None && !AttachedGrenade.bDeleteMe )
		{
			AttachedGrenade.DoExplosion();
		}
	}

	ExplosionTemplate.InitFromContentTemplate();
	ExplosionTemplate.Damage = DeathExplosionDamage;
	ExplosionTemplate.DamageRadius = DeathExplosionDamageRadius;
	SpawnLocation = Location;
	SpawnRotation = rotator(GetHeadshotLocation() - Location);
	ExplosionActor = Spawn(class'GearExplosionActor',,, SpawnLocation, SpawnRotation);

	ExplosionActor.InstigatorController = Controller;
	if (ExplosionActor.InstigatorController != None)
	{
		ExplosionActor.Instigator = ExplosionActor.InstigatorController.Pawn;
	}

	ExplosionActor.Explode(ExplosionTemplate);

	if (Mesh != None)
	{
		// Hide mesh and stop effects
		AnimTree(Mesh.Animations).SetUseSavedPose(TRUE);
	
		PushState('Flipped');
		ExtinguishPawn();
	}

	GutsComp.SetHidden(TRUE);
	LegLightningPSysComp.DetachFromAny();
	
}

/** When it dies, it goes to Flipped state
 *  Flip the mesh and pop out**/
simulated state Flipped
{
	simulated event PushedState()
	{
		local INT Index;

		// hide the extra bones
		if (Mesh!=none)
		{
			for (Index=TailBoneNames.length-1; Index >=0 ; Index-- )
			{
				Mesh.HideBoneByName(TailBoneNames[Index],PBO_Term);
			}
		}

		// turn off tail skel control, otherwise, it will continously try to fix up
		TailSkelCtrl.SetSkelControlStrength(0.f, 0.25f);		

		// translation need to undo, otherwise, it will be floating on the air
		MTO_SpecialMoveOffset.X = 0;
  		MTO_SpecialMoveOffset.Y = 0;
  		MTO_SpecialMoveOffset.Z = default.Mesh.Translation.Z;

		SetTimer(0.1, TRUE, 'Flipping');
		SetTimer(0.3, FALSE, 'StopFlipping');
	}

	// flipping
	simulated function Flipping()
	{
		local rotator NewRotation;

		NewRotation = MakeRotator(Rotation.Pitch, Rotation.Yaw, Rotation.Roll+10923);
		SetRotation(Normalize(NewRotation));
	}

	simulated event PoppedState()
	{
		ClearTimer('Flipping');
		ClearTimer('StopFlipping');
	}

	simulated function StopFlipping()
	{
		ClearTimer('Flipping');
		// reduce height, so that it stays on the ground
		SetCollisionSize(40, 20);
		SetPhysics(PHYS_Falling);

		PopState();
	}


}

// we explode on death, not equipped to play rangdolls!
simulated function PlayRagDollDeath(class<GearDamageType> GearDamageType, vector HitLoc, bool bShowGore);


/** returns TRUE if this pawn should be evaded instead of meleed against */
function bool ShouldOtherEvadeMeInsteadOfMeleeing(GearPawn Other)
{
	return true;
}

/** attach shock effect to the serapede **/
simulated function AttachShockEffect(name SocketName, vector Dir)
{
	local SkeletalMeshSocket Socket;
	local Quat RelQuat, BoneQuat, WorldQuat;

	if (SocketName!='')
	{
		Socket = Mesh.GetSocketByName(SocketName);
		WorldQuat = QuatFromRotator(rotator(Dir));
		BoneQuat = Mesh.GetBoneQuaternion(Socket.BoneName);
		RelQuat = QuatProduct(WorldQuat, QuatInvert(BoneQuat));

		// I need new direction
		AttachDamageFX( ShockEffect, Socket.BoneName, 1.0f,Socket.RelativeLocation,QuatToRotator(RelQuat), Socket.RelativeScale);
	}
}

/** Allow gearpawns to hook into the input */
simulated function PreProcessInput(GearPlayerInput Input)
{
	local bool bReversing;

	// Strafe control also turns for serapede
	Input.aTurn = FClamp(Input.aStrafe + Input.aTurn, -1.f, 1.f) * SiegeSteeringPct;

	bReversing = Input.aBaseY < 0.f ? true : false;

	// for "forward" magnitude, use overall stick displacement magnitude
	Input.aBaseY = Sqrt(Input.aStrafe * Input.aStrafe + Input.aBaseY * Input.aBaseY);
	Input.aBaseY = bReversing ? -Input.aBaseY : Input.aBaseY;

	Super.PreProcessInput(Input);
}

event MAT_BeginAIGroup(vector StartLoc, rotator StartRot)
{
	Super.MAT_BeginAIGroup(StartLoc, StartRot);
	TailSkelCtrl.SetSkelControlStrength(0.0f, 0.25f);
}

// activate the skelcontrol
event MAT_FinishAIGroup()
{
	Super.MAT_FinishAIGroup();
	TailSkelCtrl.SetSkelControlStrength(1.f, 0.f);
}

defaultproperties
{
	Begin Object Class=SkeletalMeshComponent Name=TheGutsComp
		CollideActors=true
		BlockZeroExtent=true
		BlockNonZeroExtent=false
	End Object

	GutsComp=TheGutsComp

	Begin Object class=StaticMeshComponent Name=TheDamageableComp
		CollideActors=true
		BlockZeroExtent=true
		BlockNonZeroExtent=false
	End Object
	DamageableTailSegmentComponent=TheDamageableComp

	Begin Object Name=CollisionCylinder
		CollisionHeight=+0040.000000
		CollisionRadius=+0040.000000
		BlockNonZeroExtent=true
	End Object

	PelvisBoneName=None
	bRespondToExplosions=false
	bTranslateMeshByCollisionHeight=false
	RotationRate=(Pitch=65536, Roll=65536, Yaw=65536)
	LedgeCheckThreshold=0
	bSpawnHitEffectDecals=false

	//WalkingPhysics=PHYS_NavMeshWalking
	WalkingPhysics=PHYS_Walking
	WalkableFloorZ=-1
	bCrawler=true
	bCanStrafe=true
	bCanBeHealed=false

	MovementLateralSwayPeriod=100
	MovementLateralSwayLatOffset=35

	MinTailSegmentsAlive=3
	MinTailSegmentsForRearUp=6

	FootStepPitchRange=(X=-0.5,Y=0.5)
	NumFootStepComponents=2

	SightBoneName="LookingDirection"
	//SightBoneName=none
	NeckBoneName="Segment_headoffset"

	RightHandSocketName=""
	LeftHandSocketName=""

	PeripheralVision=-1

	EyeHeight=0
	BaseEyeHeight=0

	SpecialMoveClasses(SM_Serapede_Attack)=class'GSM_Serapede_Melee'
	SpecialMoveClasses(SM_Serapede_Cringe)=class'GSM_Serapede_Cringe'

	bModifyNavPointDest=true

	HearingThreshold=500

	NoticedGUDSEvent=GUDEvent_NoticedSerapede
	SiegeTutorialType=GEARTUT_SIEGE_Serapede


	GroundSpeedMod=1.0

	CameraNoRenderCylinder_High_ViewTarget=(Radius=40,Height=45)
	CameraNoRenderCylinder_High=(Radius=40,Height=45)
	CameraNoRenderCylinder_FlickerBuffer=(Radius=4,Height=4)

	LookOffsetSize=300

	ShockSocketNames = ("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12")

	AccelRate=+768.000000
}
