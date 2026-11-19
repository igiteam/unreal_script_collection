/**
 * Copyright 1998-2011 Epic Games, Inc. All Rights Reserved.
 */
class GearFortification_Sentry extends GearFortification
	abstract;

/** attack damage at each upgrade level; if <= 0, the sentry does not attack */
var config array<int> AttackDamage;
/** attack/detect frequency at each upgrade level */
var config array<float> CheckInterval;
/** maximum range at which enemies may be detected at each upgrade level */
var config array<float> CheckRadius;
/** how much health lost each second while enemies are in range at each upgrade level */
var config array<int> DrainPerSec;
/** enemy cringe duration at each upgrade level */
var config array<float> CringeDuration;
/** damage type to use at each upgrade level */
var array< class<DamageType> > MyDamageType;

/** used to rotate gun and play firing effects */
var repnotify vector FlashLocation;
/** set when tracking a real target (not just rotating to scan for enemies) */
var repnotify bool bAcquiredTarget;
/** muzzle flash component */
var ParticleSystemComponent MuzzleFlash;
/** particle templates to hook up to the muzzle flash depending on upgrade level */
var array<ParticleSystem> MuzzleFlashTemplate;
/** firing sound */
var SoundCue FireSound;

/** attachments to add when upgraded */
var StaticMeshComponent UpgradeAttachmentTop, UpgradeAttachmentBottom;
/** targeting beam */
var ParticleSystemComponent TargetingBeam;

/** last time we played an alarm sound so it doesn't play too often */
var float LastAlarmSoundTime;
/** alarm sound to play */
var SoundCue AlarmSound;

/** bone controllers for turret rotation */
var SkelControlSingleBone GunPitchControl, GunYawControl;
/** rotation we're moving towards at RotationRate */
var rotator DesiredRotation;

/** MIC for applying damage-related parameters */
var MaterialInstanceConstant DamageMIC;
/** component for damage particle effects */
var ParticleSystemComponent DamageEffectComp;
/** particle systems to set in the damage component */
var ParticleSystem MediumDamageEffect, HighDamageEffect;

replication
{
	if (bNetDirty)
		FlashLocation, bAcquiredTarget;
}

simulated function InitializeUpgradeLevel(byte NewLevel)
{
	local SkeletalMeshComponent SkelMesh;

	Super.InitializeUpgradeLevel(NewLevel);
	if (Role == ROLE_Authority)
	{
		SetTimer(CheckInterval[UpgradeLevel], true, nameof(CheckForEnemies));
	}

	MuzzleFlash.SetTemplate(MuzzleFlashTemplate[UpgradeLevel]);

	SkelMesh = SkeletalMeshComponent(DisplayComponent[UpgradeLevel]);
	if (SkelMesh != None)
	{
		if (WorldInfo.NetMode != NM_DedicatedServer)
		{
			SkelMesh.AttachComponentToSocket(MuzzleFlash, 'MuzzleFlash');
			SkelMesh.AttachComponentToSocket(TargetingBeam, 'Laser');
			if (UpgradeLevel == 1)
			{
				UpgradeAttachmentTop.SetLightEnvironment(FortificationLightEnvironment);
				UpgradeAttachmentBottom.SetLightEnvironment(FortificationLightEnvironment);
				SkelMesh.AttachComponentToSocket(UpgradeAttachmentTop, 'Upgrade_Top_Attach');
				SkelMesh.AttachComponentToSocket(UpgradeAttachmentBottom, 'Upgrade_Base_Attach');
			}
			DamageMIC = SkelMesh.CreateAndSetMaterialInstanceConstant(0);
			DamageEffectComp = new(self) class'ParticleSystemComponent';
			DamageEffectComp.bAutoActivate = false;
			SkelMesh.AttachComponentToSocket(DamageEffectComp, 'Damage');
		}
		GunYawControl = SkelControlSingleBone(SkelMesh.FindSkelControl('GunYaw'));
		GunPitchControl = SkelControlSingleBone(SkelMesh.FindSkelControl('GunPitch'));
	}
	else if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		AttachComponent(MuzzleFlash);
	}

	FlashLocation = Location + vector(Rotation) * CheckRadius[UpgradeLevel];
	UpdateDesiredRotation();
	SetTimer(3.0, true, nameof(PickIdleTargetPoint));
}

/** @return center of mesh; since we have different ones depending on level and with different orientation, we need to do some fixup */
simulated final function vector GetOrigin()
{
	return DisplayComponent[UpgradeLevel].GetPosition() - default.DisplayComponent[UpgradeLevel].Translation;
}

/** @return whether our current rotation is close enough to DesiredRotation to allow us to fire and deal damage */
simulated final function bool IsInFiringArc()
{
	local int Value;

	Value = Abs(((GunYawControl != None) ? (GunYawControl.BoneRotation.Yaw & 65535) : (DisplayComponent[UpgradeLevel].Rotation.Yaw & 65535)) - DesiredRotation.Yaw & 65535);
	return (Value < 4096 || Value > 61440);
}

/** pick a random location to rotate towards when there are no enemies */
final function PickIdleTargetPoint()
{
	FlashLocation.X = Location.X + RandRange(-CheckRadius[UpgradeLevel], CheckRadius[UpgradeLevel]);
	FlashLocation.Y = Location.Y + RandRange(-CheckRadius[UpgradeLevel], CheckRadius[UpgradeLevel]);
	UpdateDesiredRotation();
	bForceNetUpdate = true;
}

/** checks for enemies in range every CheckInterval seconds */
final function CheckForEnemies()
{
	local Pawn TestPawn, Target;
	local GearPawn GP;
	local ImpactInfo Impact;
	local vector CheckLoc;
	local float Dist, BestDist;
	local bool bInFiringArc;

	if (WorldInfo.Game.IsInState('MatchInProgress'))
	{
		CheckLoc = GetOrigin();
		BestDist = CheckRadius[UpgradeLevel] + 1.0;
		foreach WorldInfo.AllPawns(class'Pawn', TestPawn, CheckLoc, CheckRadius[UpgradeLevel])
		{
			if ( TestPawn.Health > 0 && !TestPawn.bTearOff && !WorldInfo.GRI.OnSameTeam(TestPawn, self) &&
				TestPawn.IsValidEnemyTargetFor(None, true) &&
				Vehicle(TestPawn.Base) == None && FastTrace(TestPawn.Location, CheckLoc) )
			{
				GP = GearPawn(TestPawn);
				if (GP == None || !GP.bIgnoredByFortifications)
				{
					Dist = VSize(TestPawn.Location - CheckLoc);
					if (Dist < BestDist)
					{
						Target = TestPawn;
						BestDist = Dist;
					}
					// show all detected GearPawns in tac-com
					if (GP != None)
					{
						GP.bShowInEnemyTaccom = true;
						GP.SetTimer(CheckInterval[UpgradeLevel] * 2.0, false, nameof(GP.RemoveFromEnemyTaccom));
					}
				}
			}
		}
	}

	if (Target != None)
	{
		bAcquiredTarget = true;
		ClearTimer(nameof(PickIdleTargetPoint));
		FlashLocation = (FlashLocation == Target.Location) ? (FlashLocation + vect(0,0,1)) : Target.Location;
		UpdateDesiredRotation();
		bInFiringArc = IsInFiringArc();
		if (AttackDamage[UpgradeLevel] > 0 && bInFiringArc)
		{
			Impact.HitActor = Target;
			Impact.RayDir = Normal(Target.Location - GetOrigin());
			// handle hitting a held shield
			GP = GearPawn(Target);
			if (GP != None && GP.EquippedShield != None && TraceComponent(Impact.HitLocation, Impact.HitNormal, GP.EquippedShield.Mesh, Target.Location, GetOrigin(),, Impact.HitInfo))
			{
				Impact.HitInfo.HitComponent = GP.EquippedShield.Mesh;
				FlashLocation = Impact.HitLocation;
			}
			else
			{
				Impact.HitInfo.HitComponent = GP.Mesh;
				Impact.HitLocation = Target.Location;
			}
			Target.TakeDamage(AttackDamage[UpgradeLevel], GetDamageInstigator(), Impact.HitLocation, Impact.RayDir, MyDamageType[UpgradeLevel], Impact.HitInfo, self);
			if (GP.ShouldPlayNonDamageHitEffects(Impact, None, MyDamageType[UpgradeLevel]))
			{
				GP.PlayTakeHit(0.0, None, Impact.HitLocation, MyDamageType[UpgradeLevel], Impact.RayDir, Impact.HitInfo);
			}
			if (CringeDuration[UpgradeLevel] > 0.0)
			{
				GP = GearPawn(Target);
				// delay between cringes so enemies don't get completely locked down
				if (GP != None && GP.Health > 0 && !GP.IsDoingASpecialMove() && WorldInfo.TimeSeconds - GP.LastCoverHeadTime > 5.0)
				{
					GP.Cringe(CringeDuration[UpgradeLevel]);
				}
			}
		}
		if (WorldInfo.NetMode != NM_DedicatedServer)
		{
			PlayFiringEffects();
		}
		if (bInFiringArc || AttackDamage[UpgradeLevel] <= 0)
		{
			// drain health since we're active
			Health -= DrainPerSec[UpgradeLevel] * CheckInterval[UpgradeLevel];
			if (Health <= 0)
			{
				Explode(false);
			}
		}
		bForceNetUpdate = true;
	}
	else if (bAcquiredTarget)
	{
		bAcquiredTarget = false;
		SetTimer(3.0, true, nameof(PickIdleTargetPoint));
		if (WorldInfo.NetMode != NM_DedicatedServer)
		{
			PlayFiringEffects();
		}
		bForceNetUpdate = true;
	}
}

/** updates DesiredRotation to point at the rotation needed to point at FlashLocation */
simulated final function UpdateDesiredRotation()
{
	if (GunYawControl != None)
	{
		DesiredRotation = rotator(FlashLocation - SkeletalMeshComponent(DisplayComponent[UpgradeLevel]).GetBoneLocation('Longitude'));
	}
	else
	{
		DesiredRotation = rotator(FlashLocation - GetOrigin()) + default.DisplayComponent[UpgradeLevel].Rotation;
		// mesh isn't correctly aligned, adjust for that
		DesiredRotation.Roll = -DesiredRotation.Pitch;
		DesiredRotation.Pitch = 0;
	}
}

/** plays effects resulting from the sentry detecting an enemy */
simulated final function PlayFiringEffects()
{
	local vector NewScale3D;

	if (Role < ROLE_Authority)
	{
		UpdateDesiredRotation();
	}

	if (!bAcquiredTarget || IsZero(FlashLocation))
	{
		MuzzleFlash.DeactivateSystem();
	}
	else
	{
		if (WorldInfo.TimeSeconds - LastAlarmSoundTime >= 2.0)
		{
			PlaySound(AlarmSound, true);
			LastAlarmSoundTime = WorldInfo.TimeSeconds;
		}

		if (AttackDamage[UpgradeLevel] > 0 && IsInFiringArc())
		{
			MuzzleFlash.ActivateSystem();
			if (UpgradeLevel > 1)
			{
				//@FIXME: hacky beam scaling, should be a parameter
				NewScale3D.X = VSize(FlashLocation - MuzzleFlash.GetPosition()) / 325.0;
				NewScale3D.Y = 1.0;
				NewScale3D.Z = 1.0;
				MuzzleFlash.SetScale3D(NewScale3D);
			}
			else
			{
				GearEmitterPool(WorldInfo.MyEmitterPool).SpawnTracer(UpgradeLevel > 0 ? WTT_LongSkinnyAR : WTT_LongSkinny, MuzzleFlash.GetPosition(), rotator(FlashLocation - MuzzleFlash.GetPosition()), FlashLocation, false);
			}
			PlaySound(FireSound, true);
		}
		else
		{
			MuzzleFlash.DeactivateSystem();
		}
	}
}

simulated function UpdateDamagedEffects()
{
	local float HealthRatio;

	if (WorldInfo.NetMode != NM_DedicatedServer && Health > 0)
	{
		HealthRatio = float(Health) / float(StartingHealth[UpgradeLevel]);
		if (DamageMIC != None)
		{
			DamageMIC.SetScalarParameterValue('Damage1', 1.0 - HealthRatio);
		}
		if (DamageEffectComp != None)
		{
			if (HealthRatio < 0.33)
			{
				if (DamageEffectComp.Template != HighDamageEffect)
				{
					DamageEffectComp.SetTemplate(HighDamageEffect);
				}
				DamageEffectComp.SetActive(true);
			}
			else if (HealthRatio < 0.66)
			{
				if (DamageEffectComp.Template != MediumDamageEffect)
				{
					DamageEffectComp.SetTemplate(MediumDamageEffect);
				}
				DamageEffectComp.SetActive(true);
			}
			else
			{
				DamageEffectComp.SetActive(false);
			}
		}
	}
}

simulated event Tick(float DeltaTime)
{
	local rotator NewRotation;

	if (GunYawControl != None)
	{
		GunYawControl.BoneRotation.Yaw = fixedTurn(GunYawControl.BoneRotation.Yaw, DesiredRotation.Yaw, RotationRate.Yaw * DeltaTime);
		GunPitchControl.BoneRotation.Pitch = fixedTurn(GunPitchControl.BoneRotation.Pitch, DesiredRotation.Pitch, RotationRate.Pitch * DeltaTime);
	}
	else
	{
		NewRotation = DisplayComponent[UpgradeLevel].Rotation;
		NewRotation.Yaw = fixedTurn(NewRotation.Yaw, DesiredRotation.Yaw, RotationRate.Yaw * DeltaTime);
		NewRotation.Roll = fixedTurn(NewRotation.Roll, DesiredRotation.Roll, RotationRate.Roll * DeltaTime);
		DisplayComponent[UpgradeLevel].SetRotation(NewRotation);
	}
}

simulated event ReplicatedEvent(name VarName)
{
	if (VarName == nameof(FlashLocation) || (VarName == nameof(bAcquiredTarget) && !bAcquiredTarget))
	{
		PlayFiringEffects();
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

simulated function PlayExplosionEffect()
{
	local vector SocketLoc;

	if (SkeletalMeshComponent(DisplayComponent[UpgradeLevel]) != None)
	{
		SkeletalMeshComponent(DisplayComponent[UpgradeLevel]).GetSocketWorldLocationAndRotation('Damage', SocketLoc);
		WorldInfo.MyEmitterPool.SpawnEmitter(ExplosionEffect, SocketLoc, rotator(vect(0,0,1)));
		PlaySound(ExplosionSound, true);
	}
	else
	{
		Super.PlayExplosionEffect();
	}
}

simulated function Explode(bool bCompletelyDestroy)
{
	Super.Explode(bCompletelyDestroy);
	ClearTimer(nameof(CheckForEnemies));
	MuzzleFlash.DeactivateSystem();
	FlashLocation = vect(0,0,0);
}

state Crippled
{
	simulated event BeginState(name PreviousStateName)
	{
		Super.BeginState(PreviousStateName);

		UpgradeAttachmentTop.SetHidden(true);
		UpgradeAttachmentBottom.SetHidden(true);
		TargetingBeam.SetHidden(true);
		if (DamageEffectComp != None)
		{
			DamageEffectComp.SetActive(false);
		}
	}

	simulated event EndState(name NextStateName)
	{
		Super.EndState(NextStateName);

		if (Role == ROLE_Authority)
		{
			SetTimer(CheckInterval[UpgradeLevel], true, nameof(CheckForEnemies));
		}

		UpgradeAttachmentTop.SetHidden(false);
		UpgradeAttachmentBottom.SetHidden(false);
		TargetingBeam.SetHidden(false);
	}
}

defaultproperties
{
	Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=25.0
		CollisionHeight=78.0
		BlockNonZeroExtent=true
		BlockZeroExtent=false
		BlockActors=true
		CollideActors=true
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	bReplicateMovement=true
	bUpdateSimulatedPosition=true

	RotationRate=(Pitch=20000,Yaw=20000,Roll=20000)

	StatName=Sentry
	BuiltGUDEvent=GUDEvent_Horde_SentryBuilt
	UpgradedGUDEvent=GUDEvent_Horde_SentryUpgraded
	RepairedGUDEvent=GUDEvent_Horde_SentryRepaired
	DestroyedGUDEvent=GUDEvent_Horde_SentryDestroyed
}
