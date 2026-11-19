/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class NanoSentryTurretBase extends NanoTurretBase
	abstract
	implements(NanoInterface_Forgeable)
	config(Pawn);

var transient protected NanoAnimNodeSequence AssembleAnimSeq;

var protected ParticleSystemComponent PSC_ForgeEffect0;     // coalesce
var protected ParticleSystemComponent PSC_ForgeEffect1;     // boom
var protected ParticleSystemComponent PSC_ForgeEffect2;     // final pop

var protected transient MaterialInstanceConstant MIC_TurretMat;

var protected transient float ThreshholdParamInterpTimeRemaining;
var() protected const float ThreshholdParamInterpTime;
var() protected const vector2d ThreshholdParamInterpRange;

var protected transient float PowerPositionParamInterpTimeRemaining;
var() protected const float PowerPositionParamInterpTime;
var() protected const vector2d PowerPositionParamInterpRange;

var protected const SoundCue ForgeSound;

var protected transient array<ParticleSystemComponent> PSC_ForgeTrails;
var protected transient array<Name> PSC_ForgeTrailSockets;

var() protected class<NanoWeapon> WeaponClass;

var protected transient Actor TrackingTarget;

var() protected bool bDrawDebug;

var protected transient SkelControlLookAt AimLookatYaw;
var protected transient SkelControlLookAt AimLookatPitch;

/** 0 for left, 1 for right */
var protected transient byte ActiveBarrel;          

var() protected const float TrackingInterpSpeed;

/** Configurable health setting */
//var() config int DefaultHealth;

var protectedwrite transient bool bForging;

var ParticleSystem PS_DeathExplosionEffect;
var ParticleSystem PS_Damaged_Small;
var ParticleSystem PS_Damaged_Alot;

var transient ParticleSystemComponent PSC_Damaged_Small;
var transient ParticleSystemComponent PSC_Damaged_Alot;

var ParticleSystem PS_TookHit;


var SoundCue DeathSound;
var SoundCue ScanningSound;
var SoundCue AboutToFireSound;
var SoundCue DoneFiringSound;
var SoundCue ImpactedByWeaponSound;

var SoundCue DamagedAndOnFireSound;
var transient AudioComponent AC_DamagedAndOnFireSound;


/** When this is forged and kills someone we will the this much of the EXP.**/
var config float EXPPercentage;

/** Turrets will now self destruct after this amount of time. **/
var config float DurationBeforeSelfDestruct;


delegate OnFinishedForging();


simulated function PostBeginPlay()
{
	local int Idx;

	Super.PostBeginPlay();

	SpawnDefaultController();

	Health = DefaultHealth;

	// start Assembly anim
	AssembleAnimSeq	= NanoAnimNodeSequence(Mesh.FindAnimNode('Assemble'));

	MIC_TurretMat = Mesh.CreateAndSetMaterialInstanceConstant(0);
	Mesh.SetMaterial(1, MIC_TurretMat);
	Mesh.SetMaterial(2, MIC_TurretMat);
	Mesh.SetMaterial(3, MIC_TurretMat);
	Mesh.SetMaterial(4, MIC_TurretMat);
	Mesh.SetMaterial(5, MIC_TurretMat);
	
	Mesh.AttachComponent(PSC_ForgeEffect0, 'Object12');
	Mesh.AttachComponent(PSC_ForgeEffect1, 'Object12');
	Mesh.AttachComponent(PSC_ForgeEffect2, 'Object12');

	for (Idx=0; Idx<PSC_ForgeTrails.length; ++Idx)
	{
		Mesh.AttachComponentToSocket(PSC_ForgeTrails[Idx], PSC_ForgeTrailSockets[Idx]);
	}

	AimLookatYaw = SkelControlLookAt(Mesh.FindSkelControl('AimYaw'));
	AimLookatPitch = SkelControlLookAt(Mesh.FindSkelControl('AimPitch'));
	AimLookatYaw.TargetLocationInterpSpeed = TrackingInterpSpeed;
	AimLookatPitch.TargetLocationInterpSpeed = TrackingInterpSpeed;
	
	// Create it and add to inventory chain, only activate if we don't have a weapon currently selected
	CreateInventory(WeaponClass);
}


function InitTeam(Pawn ForgingPawn)
{
	local AIController AI;

	AI = AIController(Controller);
	if (AI != None)
	{
		AI.SetTeam(ForgingPawn.GetTeamNum());
	}

	if( NanoPawn_RebelsBase(ForgingPawn) != None )
	{
		bWasSpawnedByPlayer = TRUE;
		PawnWhoSpawnedMe = NanoPawn(ForgingPawn);

		// update the icon on the map color
		UIComponent.MiniMap.IconColor.R = 0;
		UIComponent.MiniMap.IconColor.G = 255;
		UIComponent.MiniMap.IconColor.B = 0;
	}
}


/** from NanoInterface_Forgeable */
function ForgeActor(optional delegate<NanoPlan.OnForgeActorFinished> OnFinishCallback)
{
	local int Idx;

	if (AssembleAnimSeq != None)
	{
		AssembleAnimSeq.PlayAnim();
	}

	PSC_ForgeEffect0.ActivateSystem();

	for (Idx=0; Idx<PSC_ForgeTrails.length; ++Idx)
	{
		PSC_ForgeTrails[Idx].ActivateSystem();
	}

	SetTimer(0.05f, FALSE, nameof(StartBoomForgeEffect));
	SetTimer(0.2f, FALSE, nameof(StartMICParamInterp));
	SetTimer(1.2f, FALSE, nameof(StartFinalPopEffect));
	SetTimer(1.2f, FALSE, nameof(StopCoalesceForgeEffect));
	SetTimer(1.75f, FALSE, nameof(ForgeFinished));

	PlaySound(ForgeSound);

	bForging = TRUE;
	OnFinishedForging = OnFinishCallback;
}

protected function ForgeFinished()
{
	local int Idx;

	for (Idx=0; Idx<PSC_ForgeTrails.length; ++Idx)
	{
		PSC_ForgeTrails[Idx].DeactivateSystem();
	}

	// call delegate
	if (OnFinishedForging != None)
	{
		OnFinishedForging();
	}
	bForging = FALSE;

	SetTimer( DurationBeforeSelfDestruct, FALSE, nameof(SelfDestruct) );

}

protected function StartFinalPopEffect()
{
	PSC_ForgeEffect2.ActivateSystem();
	SetTimer(1.25f, FALSE, nameof(StopFinalPopEffect));
}
protected function StopFinalPopEffect()
{
	PSC_ForgeEffect2.DeactivateSystem();
}


protected function StartMICParamInterp()
{
	ThreshholdParamInterpTimeRemaining = ThreshholdParamInterpTime;
	PowerPositionParamInterpTimeRemaining = PowerPositionParamInterpTime;
}
protected function StopCoalesceForgeEffect()
{
	PSC_ForgeEffect0.DeactivateSystem();
}
protected function StartBoomForgeEffect()
{
	PSC_ForgeEffect1.ActivateSystem();
	SetTimer(1.3f, FALSE, nameof(StopBoomForgeEffect));
}
protected function StopBoomForgeEffect()
{
	PSC_ForgeEffect1.DeactivateSystem();
}

simulated function Tick( float DeltaTime )
{
	local float Pct;
	//local vector YawTrackLoc, MuzzleWorldDelta;

	super.Tick(DeltaTime);

	if (ThreshholdParamInterpTimeRemaining > 0.f)
	{
		ThreshholdParamInterpTimeRemaining = FMax(ThreshholdParamInterpTimeRemaining-DeltaTime, 0.f);
		Pct = 1.f - ThreshholdParamInterpTimeRemaining/ThreshholdParamInterpTime;
		MIC_TurretMat.SetScalarParameterValue('Threshold', GetRangeValueByPct(ThreshholdParamInterpRange, Pct));
	}

	if (PowerPositionParamInterpTimeRemaining > 0.f)
	{
		PowerPositionParamInterpTimeRemaining = FMax(PowerPositionParamInterpTimeRemaining-DeltaTime, 0.f);
		Pct = 1.f - PowerPositionParamInterpTimeRemaining/PowerPositionParamInterpTime;
		MIC_TurretMat.SetScalarParameterValue('PowerPosition', GetRangeValueByPct(PowerPositionParamInterpRange, Pct));
	}

	if( (TrackingTarget != None) && ( Weapon != None ) )
	{
		// adjust tracking location due to barrel/muzzle offset from the yaw pivot bone, so it
		// actually hits the tracking target when it shoots.  Note this isn't fully correct, but it's close enough for now.
		//MuzzleWorldDelta = Weapon.GetMuzzleLoc() - Mesh.GetBoneLocation('Object12');
		//YawTrackLoc = TrackingTarget.Location - MuzzleWorldDelta;
		
		//AimLookatYaw.SetTargetLocation( YawTrackLoc );
 		AimLookatYaw.SetTargetLocation(TrackingTarget.Location);
		AimLookatYaw.InterpolateTargetLocation(DeltaTime);

 		AimLookatPitch.SetTargetLocation(TrackingTarget.Location);
		AimLookatPitch.InterpolateTargetLocation(DeltaTime);
	}

	if (bDrawDebug)
	{
		if (TrackingTarget != None)
		{
			DrawDebugLine(Location, TrackingTarget.Location, 255, 255, 0);
		}
	}
}


event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);


	WorldInfo.MyEmitterPool.SpawnEmitter( PS_TookHit, HitLocation );
	PlaySound( ImpactedByWeaponSound );


	if( Health < (DefaultHealth * 0.40f) )
	{
		if( PSC_Damaged_Alot == None )
		{
			PSC_Damaged_Alot = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( PS_Damaged_Alot, Mesh, 'Damaged_Alot', TRUE );
		}
	}
	else if( Health < (DefaultHealth * 0.70f) )
	{
		if( PSC_Damaged_Small == None )
		{
			PSC_Damaged_Small = WorldInfo.MyEmitterPool.SpawnEmitterMeshAttachment( PS_Damaged_Small, Mesh, 'Damaged_Small', TRUE );
		}

		if( AC_DamagedAndOnFireSound == None )
		{
			AC_DamagedAndOnFireSound = new(self) class'AudioComponent';
			AC_DamagedAndOnFireSound.SoundCue = DamagedAndOnFireSound;
			AttachComponent( AC_DamagedAndOnFireSound );
			AC_DamagedAndOnFireSound.FadeIn( 0.5f, 1.0f );
		}
	}
}


function SelfDestruct()
{
	`log( GetFuncName() );
	Suicide();
}


simulated function SetTrackingTarget(Actor NewTargetToTrack)
{
	TrackingTarget = NewTargetToTrack;
}

simulated function Vector GetWeaponStartTraceLocation(optional Weapon CurrentWeapon)
{
	return Weapon.GetMuzzleLoc();
}


function bool Died(Controller Killer, class<DamageType> DamageType, vector HitLocation)
{
	WorldInfo.MyEmitterPool.SpawnEmitter( PS_DeathExplosionEffect, Location );
	PlaySound( DeathSound );

	if( AC_DamagedAndOnFireSound != None )
	{
		AC_DamagedAndOnFireSound.FadeOut( 0.5f, 0.0f );
		AC_DamagedAndOnFireSound = None;
	}

	// for now, just stop existing
	Destroy();

	return Super.Died(Killer, DamageType, HitLocation);
}

defaultproperties
{
	ThreshholdParamInterpTime=0.5f
	ThreshholdParamInterpRange=(X=0.2f,Y=0.5f)
	PowerPositionParamInterpTime=1.9
	PowerPositionParamInterpRange=(X=-0.36f,Y=1.f)

	TrackingInterpSpeed=20.f

	//bDrawDebug=TRUE
}


